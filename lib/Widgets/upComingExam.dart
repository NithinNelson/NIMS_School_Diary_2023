import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../Util/color_util.dart';
class UpcomingExam extends StatelessWidget {
  final String? examName;
  final String? examDate;
  final Color? color;
  const UpcomingExam({Key? key,this.examName,this.examDate,this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
        children: [
          Container(
            width: 80,
            height: 120,
            margin: EdgeInsets.only(left: 20,right: 10,top: 15,bottom: 10,),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20)
            ),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Center(child: Text('${DateFormat('dd MMM').format(DateTime.parse(examDate!)).split(' ')[0]}',textScaleFactor:1.0,style: TextStyle(
                   color: ColorUtil.white,
                   fontWeight: FontWeight.w700,
                   fontFamily: "Montserrat",
                   //fontStyle:  FontStyle.normal,
                   fontSize: 20.sp),)),
               Center(child: Text('${DateFormat('dd MMM').format(DateTime.parse(examDate!)).split(' ')[1].toUpperCase()}', textScaleFactor:1.0,style: TextStyle(
                 fontFamily: 'Montserrat',
                 color: ColorUtil.white,
                 fontSize: 16.sp,
                 fontWeight: FontWeight.w400,
                 fontStyle: FontStyle.normal,
                 letterSpacing: 0,
               ),)),
               Center(child: Text('${DateFormat('dd MMM yyyy').format(DateTime.parse(examDate!)).split(' ')[2].toUpperCase()}', textScaleFactor:1.0,style: TextStyle(
                 fontFamily: 'Montserrat',
                 color: ColorUtil.white,
                 fontSize: 16.sp,
                 fontWeight: FontWeight.w400,
                 fontStyle: FontStyle.normal,
                 letterSpacing: 0,
               ),)),
             ],
           ),
          ),
          Container(
            width: 1.sw - 130,
            height: 120,
            margin: EdgeInsets.only(right: 20,top: 15,bottom: 10 ),
           // color: Colors.pink,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x24161616),
                      offset: Offset(0, 7),
                      blurRadius: 24,
                      spreadRadius: 0)
                ],
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 1.sw - 140,
                  height: 20,
                  decoration: BoxDecoration(
                    color: ColorUtil.green,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: Text(
                      'Upcoming Exam',textScaleFactor:1.0,style: TextStyle(
                      color: ColorUtil.white,
                      fontSize: 12.sp
                    ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                AutoSizeText(examName!,textScaleFactor:1.0,style: TextStyle(
                  color: color,
                  fontSize: 16.sp
                ),)
              ],
            ),
          )
        ],
      );


  }
}
