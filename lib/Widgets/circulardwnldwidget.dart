import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file_safe/open_file_safe.dart';

import '../Util/color_util.dart';

class CircularDwnldWidget extends StatelessWidget {
  final String? title;
  final String? filePath;
  final String? type;
  final String? date;
  const CircularDwnldWidget({Key? key, this.title, this.filePath,this.type,this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        OpenFile.open(filePath);
      },
      child: Container(
        width: 1.sw,
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
            // borderRadius: BorderRadius.only(
            //     bottomRight: Radius.circular(10),
            //     bottomLeft: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x1f324dab),
                  offset: Offset(0, 32),
                  blurRadius: 22,
                  spreadRadius: -8)
            ],
            gradient: LinearGradient(
                begin: Alignment(0.5, -3),
                end: Alignment(0.5, 1),
                colors: [Colors.white, const Color(0xfff8f9ff)])
           ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              textScaleFactor: 1.0,
              style: TextStyle(
                  color: ColorUtil.blue,
                  fontWeight: FontWeight.w600,
                  fontFamily: "OpenSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 13.sp),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorUtil.circularRed,
                  ),
                  child: Center(
                      child: Text(
                    //'Circular',
                        type!,
                    textScaleFactor: 1.0,
                    style: TextStyle(color: ColorUtil.white),
                  )),
                ),
                Text(
                    //'date',
                  date!,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        color: ColorUtil.greybg,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.normal,
                        fontSize: 11.sp))
              ],
            )
          ],
        ),
      ),
    );
  }
}
