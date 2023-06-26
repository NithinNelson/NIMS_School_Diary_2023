import 'dart:io';
import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Util/api_constants.dart';
import '../Util/color_util.dart';
import '../Models/circular_model.dart';
import 'attachment_widget.dart';

class CircularWidget extends StatefulWidget {
  final String? circId;
// final bool isOpen;
  final String? typeCorA;
  final String? childId;
  final DateTime? circularDate;
  final String? cicularTitle;
  final String? circularDesc;
  final String? senderName;
  final String? webLink;
  final List<String>? attachment;
  const CircularWidget(
      {Key? key,
      //  this.isOpen = false,
      this.circId,
      this.typeCorA,
      this.childId,
      this.circularDate,
      this.cicularTitle,
      this.circularDesc,
      this.senderName,
      this.attachment,
      this.webLink})
      : super(key: key);

  @override
  State<CircularWidget> createState() => _CircularWidgetState();
}

class _CircularWidgetState extends State<CircularWidget> {
  // Future openFile({required String url,String? filename}) async {
  //   final file =await downloadFile(url,filename!);
  //   if (file == null) return;
  //   print('Path:${file.path}');
  //
  //   OpenFile.open(file.path);
  // }
  // Future<File?> downloadFile(String url,String filename) async{
  //   //final appStorage = await getApplicationDocumentsDirectory();
  //   if(await Permission.storage.request().isGranted){
  //     final path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
  //     var dir = await Directory('$path/SchoolDiary/Circular');
  //     var file = File('/');
  //     if(await dir.exists()){
  //        file = File('${dir.path}/$filename');
  //     }else{
  //       var dir = await Directory('$path/SchoolDiary/Circular').create(recursive: true);
  //        file = File('${dir.path}/$filename');
  //     }
  //     try{
  //       final response = await Dio().get(url,options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //           receiveTimeout: 0,
  //
  //       ),onReceiveProgress: (rec,total){
  //         setState((){
  //           _isDownloading = true;
  //           progressPer = rec/total;
  //           progressStr = ((rec/total)*100).toStringAsFixed(0);
  //         });
  //       } );
  //
  //       final raf = file.openSync(mode: FileMode.write);
  //       raf.writeFromSync(response.data);
  //       await raf.close();
  //       setState((){
  //         _isDownloading = false;
  //         _isDownloaded = true;
  //       });
  //       return file;
  //
  //     }catch(e){
  //       print(e);
  //       return null;
  //     }
  //   }
  //
  //
  // }
  DateFormat _examformatter = DateFormat('dd MMM');
  var _isOpen = false;
  String? idFrDa;
  //var _isOpen = false;
  // var _isDownloading = false;
  // var _isDownloaded = false;
  // var progressStr = "";
  // var progressPer = 0.0;

  dashboardLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final String? idfrom = prefs.getString('dashId');
    idFrDa = idfrom;
    print('dashboard id -----$idFrDa');
    if (idFrDa == null) return;
    if (idFrDa == widget.circId) {
      setState(() {
        _isOpen = true;
      });
      prefs.remove('dashId');
    }
  }

  Future<void> _launchUrl(String url) async {
    String webLink = url;
    print('------------webLink----------$webLink');
    try {
      if (!await launchUrl(Uri.parse(webLink), mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $webLink';
      }
    } catch (e) {
      print('-----gr-------${e.toString()}');
    }
  }

  @override
  void initState() {
    dashboardLoad();
    // print('iiiiiiiiiiii------${widget.isOpen}');
    // _isOpen = widget.isOpen;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isOpen = !_isOpen;
              });
            },
            child: Container(
              width: 1.sw,
              height: 100,
              padding: EdgeInsets.all(15),
              // margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  // border: Border(bottom: BorderSide(width: 1,color: ColorUtil.borderSep.withOpacity(0.1))),
                  // borderRadius: BorderRadius.only(
                  //     topRight: Radius.circular(10),
                  //     topLeft: Radius.circular(10)),
                  borderRadius: _isOpen
                      ? BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10))
                      : BorderRadius.circular(10),
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: const Color(0x1f324dab),
                  //       offset: Offset(0, 32),
                  //       blurRadius: 22,
                  //       spreadRadius: -8)
                  // ],
                  gradient: LinearGradient(
                      begin: Alignment(0.5, -3),
                      end: Alignment(0.5, 1),
                      colors: [Colors.white, const Color(0xfff8f9ff)])),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      color: ColorUtil.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _examformatter
                              .format(widget.circularDate!)
                              .split(' ')[0],
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 20.0),
                        ),
                        Text(
                          _examformatter
                              .format(widget.circularDate!)
                              .split(' ')[1]
                              .toUpperCase(),
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 1.sw - 170,
                    height: 50,
                    child: AutoSizeText(
                      widget.cicularTitle!,
                      maxLines: 2,
                      style: TextStyle(
                          color: ColorUtil.blue, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    _isOpen
                        ? Icons.arrow_drop_up_outlined
                        : Icons.arrow_drop_down_outlined,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
          ),
          _isOpen ? Container(
            width: 1.sw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              // boxShadow: [
              //   BoxShadow(
              //       //color: const Color(0x1f324dab),
              //     color: ColorUtil.mainBg,
              //       offset: Offset(0, 5),
              //       blurRadius: 5,
              //       spreadRadius: 0)
              // ],
              gradient: LinearGradient(
                  begin: Alignment(0.5, -3),
                  end: Alignment(0.5, 1),
                  colors: [Colors.white, const Color(0xfff8f9ff)]),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(90, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.circularDesc!,
                    textScaleFactor: 0.95,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  (widget.webLink != null && widget.webLink != "")? InkWell(
                    onTap: (){
                      _launchUrl(widget.webLink!);
                    },
                    child: Container(
                      height: 35,
                      width: 200,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          color: ColorUtil.blue,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text('Open Weblink',textScaleFactor:1,style: TextStyle(
                            color: ColorUtil.white
                        ),),
                      ),
                    ),
                  ) : SizedBox(),
                  Container(
                    height: double.parse("${widget.attachment!.length}") * 40,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.attachment!.isEmpty
                            ? 0
                            : widget.attachment!.length,
                        itemBuilder: (ctx, i) =>
                        // Text('atta$i-${widget.attachment![i]}'),
                        //attachment(widget.cicularTitle!,widget.attachment![i],i)
                        AttachmentWidget(
                          type: widget.typeCorA,
                          childId: widget.childId,
                          attUrl: widget.attachment![i],
                          circularTitle: widget.cicularTitle!,
                          circularDesc: widget.circularDesc!,
                          totalAtt: i,
                          issuedBy: widget.senderName!,
                        )),
                  ),
                  Text(
                    'Issued by ${widget.senderName!}',
                    textScaleFactor:1.0,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ) : Container(),
          // Container(
          //   width: 1.sw,
          //   height: _isOpen
          //       ? (widget.webLink != null)? 120 +
          //           widget.attachment!.length * 45 +
          //           widget.circularDesc!.length * 0.6 : 80 +
          //       widget.attachment!.length * 45 +
          //       widget.circularDesc!.length * 0.6
          //       : 0,
          //   padding: _isOpen
          //       ? EdgeInsets.only(bottom: 10, top: 10)
          //       : EdgeInsets.only(bottom: 0),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.only(
          //         bottomRight: Radius.circular(10),
          //         bottomLeft: Radius.circular(10)),
          //     // boxShadow: [
          //     //   BoxShadow(
          //     //       //color: const Color(0x1f324dab),
          //     //     color: ColorUtil.mainBg,
          //     //       offset: Offset(0, 5),
          //     //       blurRadius: 5,
          //     //       spreadRadius: 0)
          //     // ],
          //     gradient: LinearGradient(
          //         begin: Alignment(0.5, -3),
          //         end: Alignment(0.5, 1),
          //         colors: [Colors.white, const Color(0xfff8f9ff)]),
          //   ),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: 90,
          //       ),
          //       Container(
          //         width: 1.sw - 120,
          //         // height: widget.attachment!.length * 50,
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(widget.circularDesc!,textScaleFactor:1.0,style: TextStyle(
          //               fontSize: 14
          //             ),),
          //             SizedBox(
          //               height: 6,
          //             ),
          //             (widget.webLink != null)? InkWell(
          //               onTap: (){
          //                _launchUrl(widget.webLink!);
          //               },
          //               child: Container(
          //                 height: 35,
          //                 width: 200,
          //                 margin: EdgeInsets.only(bottom: 5),
          //                 decoration: BoxDecoration(
          //                   color: ColorUtil.blue,
          //                   borderRadius: BorderRadius.circular(10)
          //                 ),
          //                 child: Center(
          //                   child: Text('Open Weblink',textScaleFactor:1,style: TextStyle(
          //                     color: ColorUtil.white
          //                   ),),
          //                 ),
          //               ),
          //             ) : SizedBox(),
          //             Expanded(
          //               child: ListView.builder(
          //                   physics: NeverScrollableScrollPhysics(),
          //                   itemCount: widget.attachment!.isEmpty
          //                       ? 0
          //                       : widget.attachment!.length,
          //                   itemBuilder: (ctx, i) =>
          //                       // Text('atta$i-${widget.attachment![i]}'),
          //                       //attachment(widget.cicularTitle!,widget.attachment![i],i)
          //                       AttachmentWidget(
          //                         type: widget.typeCorA,
          //                         childId: widget.childId,
          //                         attUrl: widget.attachment![i],
          //                         circularTitle: widget.cicularTitle!,
          //                         circularDesc: widget.circularDesc!,
          //                         totalAtt: i,
          //                         issuedBy: 'Issued by ${widget.senderName!}',
          //                       )),
          //             ),
          //             Text('Issued by ${widget.senderName!}',textScaleFactor:1.0,style: TextStyle(fontSize: 14),)
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
  // Widget attachment(String title,String url,int nos) => Container(
  //   //width: 100,
  //   height: 40,
  //   color: Colors.white,
  //   child: Row(children: [
  //     Container(
  //       width: 200,
  //       height: 32,
  //       //color: Colors.blue,
  //       decoration: BoxDecoration(
  //           color: ColorUtil.attachmentColor,
  //           borderRadius: BorderRadius.circular(10)
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(4.0),
  //         child: Row(
  //
  //           children: [
  //             Transform.rotate(
  //                 angle: 270 * math.pi/180,
  //                 child: Icon(Icons.attachment,color: ColorUtil.white,)),
  //             SizedBox(width: 4,),
  //             Text('Attachment-${nos+1}',style: TextStyle(
  //                 color: ColorUtil.white
  //             ),),
  //             SizedBox(width: 38,),
  //             _isDownloaded? Icon(Icons.remove_red_eye_outlined,color: ColorUtil.white,) : _isDownloading?
  //             CircularPercentIndicator(
  //               radius: 12,
  //               lineWidth: 4.0,
  //               percent: progressPer,
  //               //fillColor: ColorUtil.white,
  //               backgroundColor: ColorUtil.white,
  //               progressColor: ColorUtil.navyBlue,
  //               center: Text(progressStr,style: TextStyle(color: ColorUtil.white,fontSize: 6.sp),),
  //             ):  InkWell(
  //                 onTap: (){
  //                   openFile(url: '${ApiConstants.downloadUrl}$url',filename: '${widget.cicularTitle}_${widget.childId}_${url.split('/').last}');
  //                 },
  //                 child: Icon(Icons.arrow_circle_down,color: Colors.white,))
  //           ],
  //         ),
  //       ),
  //     ),
  //     SizedBox(width: 5,),
  //     Icon(Icons.share,color: ColorUtil.shareColor,)
  //   ],),
  // );
}
