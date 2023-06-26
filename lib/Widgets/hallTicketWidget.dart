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

import '../Util/color_util.dart';

class HallTicketWidget extends StatefulWidget {
  final String? childId;
  final String? title;
  final String? url;
  final DateTime? date;
  const HallTicketWidget(
      {Key? key, this.date, this.url, this.title, this.childId})
      : super(key: key);

  @override
  State<HallTicketWidget> createState() => _HallTicketWidgetState();
}

class _HallTicketWidgetState extends State<HallTicketWidget> {
  var checkPermission;
  var _isDownloading = false;
  var _isDownloaded = false;
  var progressStr = "";
  var progressPer = 0.0;
  var currentpath = '';

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
      // final path = await ExternalPath.getExternalStoragePublicDirectory(
      //     ExternalPath.DIRECTORY_DOWNLOADS);
      final path = (await getApplicationDocumentsDirectory()).path;
      var dir = await Directory('$path/SchoolDiary/HallTicket');
      var file = File('/');
      if (await dir.exists()) {
        file = File(
            '${dir.path}/${widget.title}_${widget.childId}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_HallTicket.pdf');
      } else {
        var dir = await Directory('$path/SchoolDiary/HallTicket')
            .create(recursive: true);
        file = File(
            '${dir.path}/${widget.title}_${widget.childId}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_HallTicket.pdf');
      }
      await file.writeAsBytes(bytes);
      var fileSaved = await file.writeAsBytes(bytes);
      print("file : $fileSaved");
      checkExist();
    }
  }

  Future checkExist() async {
    // print('Url-------------------->${widget.attUrl}');
    // print('childId---------------->${widget.childId}');
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
      var dir = await Directory('$path/SchoolDiary/HallTicket');
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
          print(widget.childId);
          print(file.path.split('/').last.split('_')[1].runtimeType);
          print(widget.childId.runtimeType);
          //print(widget.title);
          if ((file.path.split('/').last.split('_')[1] == widget.childId) &&
              (file.path.split('/').last.split('_')[0] == widget.title)) {
            setState(() {
              _isDownloaded = true;
              _isDownloading = false;
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
      //height: 100,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 1.sw - 100,
                // height: 60,

                child: AutoSizeText(
                  widget.title!,
                  textScaleFactor: 1.0,
                  //maxLines: 2,
                  style: TextStyle(
                    color: ColorUtil.tabIndicator,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Axiforma",
                    // fontStyle:  FontStyle.normal,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              _isDownloading? Container(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  backgroundColor: Colors.green,
                ),
              ):
              _isDownloaded
                  ? GestureDetector(
                      onTap: () {
                        OpenFile.open(currentpath);
                      },
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: ColorUtil.green,
                      ))
                  : GestureDetector(
                      onTap: () {
                        initiateDownload(widget.url!);
                      },
                      child: Icon(
                        Icons.arrow_circle_down,
                        color: ColorUtil.green,
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                width: 160,
                //color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Issued On',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: ColorUtil.downloadClr.withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                          //fontFamily: "Axiforma",
                          fontStyle: FontStyle.italic,
                          fontSize: 10),
                    ),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: ColorUtil.downloadClr,
                    ),
                    Text(
                      '${DateFormat('dd-MM-yyyy').format(widget.date!)}',
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: ColorUtil.calendarFont,
                          fontWeight: FontWeight.w400,
                          //fontFamily: "Axiforma",
                          //fontStyle:  FontStyle.normal,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
