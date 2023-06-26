import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../Util/api_constants.dart';
import '../Util/color_util.dart';

class AttachmentWidget extends StatefulWidget {
  final String? type;
  final int? totalAtt;
  final String? attUrl;
  final String? circularTitle;
  final String? childId;
  final String? issuedBy;
  final String? circularDesc;
  const AttachmentWidget(
      {Key? key,
      this.totalAtt,
      this.attUrl,
      this.childId,
      this.circularTitle,
      this.circularDesc,
      this.type,
        this.issuedBy})
      : super(key: key);

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  var _isDownloading = false;
  var _isDownloaded = false;
  var _doneLoading = false;
  var progressStr = "";
  var progressPer = 0.0;
  var currentpath = '';
  var schoolName = '';
  var init = true;
  var checkPermission;

  permissionCheck() async {
    print('init------------->$init');
    var status = await Permission.storage.status;
    checkPermission = status.isGranted;
    if (status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        checkPermission = true;
        init = false;
        print('init------------->$init');
      }
    }
  }

  Future checkExist() async {
    print('Url-------------------->${widget.attUrl}');
    print('childId---------------->${widget.childId}');
    var status = await Permission.storage.status;
    print(status.isGranted);
    checkPermission = status.isGranted;
    print(checkPermission);
    // if (status.isDenied) {
    //   if (await Permission.storage.request().isGranted) {
    //     checkPermission = true;
    //   }
    // }
    if (checkPermission == true) {
      // final path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
      final path = (await getApplicationDocumentsDirectory()).path;
      print('path-------->$path');
      var dir = await Directory('$path/SchoolDiary/${widget.type}');
      try {
        var files = dir.listSync();
        print(files.length);
        files.forEach((file) {
          print('file path---------------->${file.path}');
          print('${file.path.split('/').last.split('_').last}');
          print('${widget.attUrl!.split('/').last.split('_').last}');
          print(widget.childId);
          print('${file.path.split('/').last.split('_')[1]}');
          if ((file.path.split('/').last.split('_').last ==
                  widget.attUrl!.split('/').last.split('_').last) &&
              (file.path.split('/').last.split('_')[1] == widget.childId)) {
            currentpath = file.path;
            setState(() {
              _isDownloaded = true;
            });
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future openFile({required String url, String? filename}) async {
    final file = await downloadFile(url, filename!);
    if (file == null) return;
    print('Path:${file.path}');

    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, String filename) async {
    print(url);
    //final appStorage = await getApplicationDocumentsDirectory();
    if (await Permission.storage.request().isGranted) {
      setState(() {
        _isDownloading = true;
      });
      //final path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
      final path = (await getApplicationDocumentsDirectory()).path;
      var dir = await Directory('$path/SchoolDiary/${widget.type}');

      var file = File('/');
      if (await dir.exists()) {
        file = File('${dir.path}/$filename');
      } else {
        var dir = await Directory('$path/SchoolDiary/${widget.type}')
            .create(recursive: true);
        file = File('${dir.path}/$filename');
      }
      try {
        Dio dio = Dio();
        dio.download(url, '${dir.path}/$filename',
            onReceiveProgress: (rec, total) {
          setState(() {
            progressPer = rec / total;
            progressStr = ((rec / total) * 100).toStringAsFixed(0);
          });
          if (progressStr == '100') {
            _isDownloading = false;
          }
        }).then((_) async {
          if (progressStr == '100') {
            //_isDownloaded = true;
            await checkExist().then((value) {
              setState(() {
                _doneLoading = true;
              });
            });
          }
        });
        // final response = await Dio().get(url,options: Options(
        //   responseType: ResponseType.bytes,
        //   followRedirects: false,
        //   receiveTimeout: 0,
        //
        // ),onReceiveProgress: (rec,total){
        //   setState((){
        //     _isDownloading = true;
        //     progressPer = rec/total;
        //     progressStr = ((rec/total)*100).toStringAsFixed(0);
        //   });
        // } );
        //
        // final raf = file.openSync(mode: FileMode.write);
        // raf.writeFromSync(response.data);
        // await raf.close();
        if (_doneLoading) {
          setState(() {
            _isDownloading = false;
            _isDownloaded = true;
          });
        }
        return file;
      } catch (e) {
        print(e);
        return null;
      }
    }
  }

  _onShare(context, String url) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      url,
      // subject: subject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  Future _fetchSchoolName() async {
    final prefs = await SharedPreferences.getInstance();
    String? output = prefs.getString('loginResp');
    if (output != null) {
      var resp = json.decode(output);
      String schoolId = resp['data']['data'][0]['school_id'];
      switch(schoolId) {
        case "CPpbKPQTcuG97i3kv": schoolName = "New Indian Model School, Dubai";
        break;
        case "m2LMtqaESFZf6xDE8": schoolName = "The Central School, Dubai";
        break;
        case "2FwuqhgeoKt6SQiCG": schoolName = "New Indian Model School, Al Ain";
        break;
        case "ps4vyLJhQvPZjfxaH": schoolName = "New Indian Model School, Sharjah";
        break;
        default: schoolName = "The Oxford School";
      }
    }
  }

  @override
  void initState() {
    if (init = true) {
      //permissionCheck();
    }
    checkExist();
    _fetchSchoolName(); // for display at share content
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 100,
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xfff8f9ff),
        // gradient: LinearGradient(
        //     begin: Alignment(0.5, -3),
        //     end: Alignment(0.5, 1),
        //     colors: [Colors.white, const Color(0xfff8f9ff)])
      ),
      //color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 200,
            height: 35,
            //color: Colors.blue,
            decoration: BoxDecoration(
                color: ColorUtil.attachmentColor,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Transform.rotate(
                      angle: 270 * math.pi / 180,
                      child: Icon(
                        Icons.attachment,
                        color: ColorUtil.white,
                      )),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Attachment-${widget.totalAtt! + 1}',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: ColorUtil.white, fontSize: 14),
                  ),
                  SizedBox(
                    width: 38,
                  ),
                  _isDownloaded
                      ? InkWell(
                          onTap: () {
                            OpenFile.open(currentpath);
                          },
                          child: Icon(
                            Icons.remove_red_eye_outlined,
                            color: ColorUtil.white,
                          ))
                      : _isDownloading
                          ? CircularPercentIndicator(
                              radius: 12,
                              lineWidth: 4.0,
                              percent: progressPer,
                              //fillColor: ColorUtil.white,
                              backgroundColor: ColorUtil.white,
                              progressColor: ColorUtil.navyBlue,
                              center: Text(
                                progressStr,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: ColorUtil.white, fontSize: 6.sp),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                //openFile(url: '${ApiConstants.downloadUrl}${widget.attUrl}',filename: '${widget.circularTitle}_${widget.childId}_${widget.attUrl!.split('/').last}');
                                downloadFile(
                                    '${ApiConstants.downloadUrl}${widget.attUrl}',
                                    '${widget.circularTitle}_${widget.childId}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${widget.attUrl!.split('/').last}');
                              },
                              child: Icon(
                                Icons.arrow_circle_down,
                                color: Colors.white,
                              ))
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
              onTap: () {
                String content = "${widget.type} From : $schoolName \n"
                    "Title : ${widget.circularDesc} \n"
                    "Description : ${widget.circularDesc} \n"
                    "Click here for attachment : ${ApiConstants.downloadUrl}${widget.attUrl} \n"
                    "Issued By : ${widget.issuedBy}";
                _onShare(
                    context, content);
                //print('${ApiConstants.downloadUrl}${widget.attUrl}');
                //Share.share('${ApiConstants.downloadUrl}${widget.attUrl}');
              },
              child: Icon(
                Icons.share,
                color: ColorUtil.shareColor,
              ))
        ],
      ),
    );
  }
}
