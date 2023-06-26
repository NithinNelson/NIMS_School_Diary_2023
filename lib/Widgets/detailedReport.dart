import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../Provider/user_provider.dart';
import '../Util/color_util.dart';

class DetailedReport extends StatefulWidget {
  final String? title;
  final String? rcId;
  final String? schlId;
  final String? stdId;
  final List<String>? subjects;
  final Map<String, dynamic>? detailedList;
  const DetailedReport(
      {Key? key,
        this.title,
      this.subjects,
      this.detailedList,
      this.stdId,
      this.schlId,
      this.rcId})
      : super(key: key);

  @override
  State<DetailedReport> createState() => _DetailedReportState();
}

class _DetailedReportState extends State<DetailedReport> {
  var _isFetched = false;
  var checkPermission;
  var _isDownloading = false;
  var _isDownloaded = false;
  var progressStr = "";
  var progressPer = 0.0;
  var currentpath = '';
  var path = '';
  initiateDownload(String url) async {
    setState(() {
      _isDownloading = true;
    });
    final encodedString = url.split(',');
    Uint8List bytes = base64.decode(encodedString[1]);
    print("file bytes >>>>>>>>>  : ${bytes.length}");
    // bytes.forEach((bit) {
    //   setState((){
    //     progressPer = bit/bytes.length * 100;
    //     print(progressPer);
    //   });
    // });
    if (await Permission.storage.request().isGranted) {
      if(Platform.isAndroid){
         // path = await ExternalPath.getExternalStoragePublicDirectory(
         //    ExternalPath.DIRECTORY_DOWNLOADS);
        path = (await getApplicationDocumentsDirectory()).path;
      }else{
        path = (await getApplicationDocumentsDirectory()).path;
      }

    //  final path = await getApplicationDocumentsDirectory();
      var dir = await Directory('$path/SchoolDiary/Report');
      var file = File('/');
      if (await dir.exists()) {
        file = File(
            '${dir.path}/${widget.title}_${widget.stdId}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${widget.rcId}_Report.pdf');
      } else {
        var dir =
            await Directory('$path/SchoolDiary/Report').create(recursive: true);
        file = File(
            '${dir.path}/${widget.title}_${widget.stdId}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${widget.rcId}_Report.pdf');
      }
      await file.writeAsBytes(bytes);
      var fileSaved = await file.writeAsBytes(bytes);
      print("file : $fileSaved");
      checkExist();
    }
  }

  Future checkExist() async {
    print('function init------');
    // print('Url-------------------->${widget.attUrl}');
    // print('childId---------------->${widget.childId}');
    var status = await Permission.storage.status;
    print(status.isGranted);
    checkPermission = status.isGranted;
    print('check per------$checkPermission');
    // if (status.isDenied) {
    //   if (await Permission.storage.request().isGranted) {
    //     checkPermission = true;
    //   }
    // }
    if (checkPermission == true) {
      if(Platform.isAndroid){
        // path = await ExternalPath.getExternalStoragePublicDirectory(
        //     ExternalPath.DIRECTORY_DOWNLOADS);
        path = (await getApplicationDocumentsDirectory()).path;
      }else{
        path = (await getApplicationDocumentsDirectory()).path;
      }
     // final path = await getApplicationDocumentsDirectory();
      print('path-------->$path');
      var dir = await Directory('$path/SchoolDiary/Report');
      try {
        var files = dir.listSync();
        print(files.length);
        files.forEach((file) {
          //print(file);
          print(file.path.split('/').last.split('_')[0]);
          print(file.path.split('/').last.split('_')[1]);
          print(file.path.split('/').last.split('_')[2]);
          print(file.path.split('/').last.split('_')[3]);
          //print(file.path.split('/').last.split('_')[4]);
          //print(file.path.split('/').last.split('_')[4].split('.')[0]);
          print(file.path.split('/').last.split('_')[1]);
          print(widget.stdId);
          print(file.path.split('/').last.split('_')[1].runtimeType);

          //print(widget.title);
          if ((file.path.split('/').last.split('_')[1] == widget.stdId) &&
              (file.path.split('/').last.split('_')[3] == widget.rcId)) {
            setState(() {
              _isDownloaded = true;
              _isDownloading = false;
              _isFetched = false;
            });
            currentpath = file.path;
          } else {
            print('not set');
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  _getdetReport(
      String consoleId, String schlId, String stdId, bool mndet) async {
    try {
      setState(() {
        //reporFrom = [];
        _isFetched = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getDetailedReport(consoleId, schlId, stdId, mndet);
      // print(resp.runtimeType);
      //report.clear();
      // print('report card length ---------->${report.length}');
      print('staus code-------------->${resp['status']['code']}');
      print(resp['data']['details']['response']['pdf_data']);
      //detailedMark = resp['data']['details']['response']['all_subjects'];

      if (resp['status']['code'] == 200) {
        initiateDownload(resp['data']['details']['response']['pdf_data']);
        setState(() {
          //_isFetched = false;
        });
      }
    } catch (e) {
      setState(() {
        _isFetched = false;
      });
    }
  }

  String markObtained(String keyy) {
    if (widget.detailedList!.containsKey(keyy)) {
      //print('OK');
      //print(keyy);
      return widget.detailedList![keyy]['total_mark'].toString();
    } else {
      return ' ';
    }
  }

  String maxMark(String keyy) {
    if (widget.detailedList!.containsKey(keyy)) {
      //print('OK');
      //print(keyy);
      return widget.detailedList![keyy]['out_of_mark'].toString();
    } else {
      return ' ';
    }
  }

  String grade(String keyy) {
    if (widget.detailedList!.containsKey(keyy)) {
      //print('OK');
      //print(keyy);
      if (widget.detailedList![keyy]['grade'] != null) {
        return widget.detailedList![keyy]['grade'].toString();
      } else {
        return 'NA';
      }
    } else {
      return ' ';
    }
  }

  List<Color> _colors = [
    ColorUtil.circularRed,
    ColorUtil.green,
    ColorUtil.subBlue,
    ColorUtil.subGold
  ];
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
      // height: 65 * double.parse(widget.subjects!.length.toString()) + 140,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Table(
            border: TableBorder(
                horizontalInside: BorderSide(
                    width: 1,
                    color: ColorUtil.totalDaysIndicator.withOpacity(0.5))),
            columnWidths: {
              0: FlexColumnWidth(3.5),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
            },
            children: [
              TableRow(children: [
                Container(
                  constraints: BoxConstraints(
                      minHeight: 60
                  ),
                  //padding: EdgeInsets.only(right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subject',
                        textScaleFactor: 1.0,
                        style: tableHeaderStyle(),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      minHeight: 60
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mark',
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: tableHeaderStyle(),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      minHeight: 60
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' Total',
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: tableHeaderStyle(),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      minHeight: 60
                  ),
                  //padding: EdgeInsets.only(right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grade',
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: tableHeaderStyle(),
                      ),
                    ],
                  ),
                )
              ]),
              ...widget.subjects!
                  .asMap()
                  .map((index, element) => MapEntry(
                      index,
                      TableRow(children: [
                        Container(
                          //height: 50,
                          constraints: BoxConstraints(
                            minHeight: 60
                          ),
                          //padding: EdgeInsets.symmetric(vertical: 15),
                          child:(element.toString() != 'Co-scholastic')? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                               '$element' ,
                                textScaleFactor: 1.0,
                                minFontSize: 14,
                                style: tableElementStyle(index),
                              ),
                            ],
                          ): Container(),
                        ),
                        (element.toString() != 'Co-scholastic')?  Container(
                          constraints: BoxConstraints(
                              minHeight: 60
                          ),
                          padding: EdgeInsets.only(left: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(

                                markObtained(element),
                                textScaleFactor: 1.0,
                                style: tableElementStyle(index),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ):Container(),
                        (element.toString() != 'Co-scholastic')? Container(
                          constraints: BoxConstraints(
                              minHeight: 60
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                maxMark(element),
                                textScaleFactor: 1.0,
                                style: tableElementStyle(index),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ):Container(),
                        (element.toString() != 'Co-scholastic')?Container(
                          constraints: BoxConstraints(
                              minHeight: 60
                          ),
                          padding: EdgeInsets.only(left: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                grade(element),
                                textScaleFactor: 1.0,
                                style: tableElementStyle(index),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ): Container()
                      ])))
                  .values
                  .toList()
            ],
          ),
          //SizedBox(height: 10,),
          _isFetched
              ? Container(
                  width: 25,
                  height: 25,
                 margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            //padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  //padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                    strokeWidth: 4,
                  ),
                )
              : _isDownloaded
                  ? GestureDetector(
                      onTap: () {
                        OpenFile.open(currentpath);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Column(
                          children: [
                            Icon(Icons.remove_red_eye_outlined,color: ColorUtil.green,),
                            Text(
                              'View File',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontFamily: 'Axiforma',
                                color: ColorUtil.downloadClr,
                                fontSize: 7,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            )
                          ],
                        ),
                      ))
                  : GestureDetector(
                      onTap: () {
                        _getdetReport(
                            widget.rcId!, widget.schlId!, widget.stdId!, false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_download_outlined,
                              color: ColorUtil.downloadClr,
                            ),
                            Text(
                              'Download File',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                fontFamily: 'Axiforma',
                                color: ColorUtil.downloadClr,
                                fontSize: 7,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
        ],
      ),
    );
  }

  tableHeaderStyle() => TextStyle(
      color: ColorUtil.totalDaysIndicator,
      fontWeight: FontWeight.w400,
      //fontFamily: "Axiforma",
      //fontStyle:  FontStyle.normal,
      fontSize: 16);
  tableElementStyle(int index) => TextStyle(
      color: (index >= 4) ? _colors[index % 4] : _colors[index],
      fontWeight: FontWeight.w400,
      //fontFamily: "Axiforma",
      //fontStyle:  FontStyle.normal,
      fontSize: 12);
}
