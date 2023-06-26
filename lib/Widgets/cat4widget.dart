import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Util/api_constants.dart';
import '../Util/color_util.dart';

class CatFour extends StatefulWidget {
  final String? type;
  final String? childId;
  final String? title;
  final String? url;
  final String? date;
  const CatFour(
      {Key? key, this.title, this.url, this.date, this.childId, this.type})
      : super(key: key);

  @override
  State<CatFour> createState() => _CatFourState();
}

class _CatFourState extends State<CatFour> {
  var _isDownloading = false;
  var _isDownloaded = false;
  var progressStr = "";
  var progressPer = 0.0;
  var currentpath = '';
  var init = true;
  var checkPermission;
  Future checkExist() async {
    print('Url-------------------->${widget.url}');
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
      // final path = await ExternalPath.getExternalStoragePublicDirectory(
      //     ExternalPath.DIRECTORY_DOWNLOADS);
      final path = (await getApplicationDocumentsDirectory()).path;
      print('path-------->$path');
      var dir = await Directory('$path/SchoolDiary/${widget.type}');
      try {
        var files = dir.listSync();
        print(files.length);
        files.forEach((file) {
          print('file path---------------->${file.path}');
          print('${file.path.split('/').last.split('_').last}');
          print('${widget.url!.split('/').last.split('_').last}');
          print(widget.childId);
          print('${file.path.split('/').last.split('_')[1]}');
          if ((file.path.split('/').last.split('_').last ==
                  widget.url!.split('/').last.split('_').last) &&
              (file.path.split('/').last.split('_')[1] == widget.childId)) {
            currentpath = file.path;
            print('current path -----------$currentpath');
            setState(() {
              _isDownloaded = true;
              print('download completed ------$_isDownloaded');
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
      // final path = await ExternalPath.getExternalStoragePublicDirectory(
      //     ExternalPath.DIRECTORY_DOWNLOADS);
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
          progressPer = rec / total;
          progressStr = ((rec / total) * 100).toStringAsFixed(0);
          if (progressStr == '100') {
            _isDownloading = false;
          }
        }).then((_) {
          if (progressStr == '100') {
            //_isDownloaded = true;
            checkExist();
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
        setState(() {
          _isDownloading = false;
          _isDownloaded = true;
        });
        return file;
      } catch (e) {
        print(e);
        return null;
      }
    }
  }
  @override
  void initState() {
    checkExist();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x94aeaed8),
            offset: Offset(0, 10),
            blurRadius: 32,
            spreadRadius: 0,
          ),
        ],
      ),
      // color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title!,
            textScaleFactor: 1.0,
            style: TextStyle(
                color: ColorUtil.tabIndicator,
                fontWeight: FontWeight.w500,
                fontFamily: "Axiforma",
                // fontStyle:  FontStyle.normal,
                fontSize: 18.sp),
          ),
          Container(
            width: 80,
            //color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${DateFormat('MMM dd').format(DateTime.parse(widget.date!))}',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: ColorUtil.calendarFont,
                      fontWeight: FontWeight.w400,
                      //fontFamily: "Axiforma",
                      //fontStyle:  FontStyle.normal,
                      fontSize: 14.sp),
                ),
                _isDownloaded
                    ? InkWell(
                        onTap: () {
                          OpenFile.open(currentpath);
                        },
                        child: Icon(
                          Icons.remove_red_eye_outlined,
                          color: ColorUtil.green,
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
                              downloadFile(
                                  //'${ApiConstants.downloadUrl}${widget.url}',
                                '${widget.url}',
                                  '${widget.title}_${widget.childId}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${widget.url!.split('/').last}');
                              print('download funct');
                            },
                            child: Icon(
                              Icons.arrow_circle_down,
                              color: ColorUtil.green,
                            ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
