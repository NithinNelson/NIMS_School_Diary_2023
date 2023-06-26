import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AFLRemark extends StatelessWidget {
  final String? remedial;
  const AFLRemark({Key? key,this.remedial}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      //height: 550,
      // color: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: EdgeInsets.only(top: 0, bottom: 50, left: 10, right: 10),
      // color: Colors.red,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: const Color(0x78aeaed8),
                offset: Offset(0, 10),
                blurRadius: 32,
                spreadRadius: 0)
          ],
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1.sw - 220,
            height: 50,
            //color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 25,
                    height: 25,
                    decoration: new BoxDecoration(
                        color: Color(0xfffc5c65),
                        borderRadius: BorderRadius.circular(5)
                    )
                ),
                Text('Teacher Analysis',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                  fontFamily: 'Axiforma',
                  color: Color(0xff000000),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,

                ),)
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 1.sw,
           // height: 200,
            //color: Colors.blue,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)
                  ),
                  border: Border.all(
                      color:  Color(0xff707070),
                      width: 1
                  ),
                  color: Colors.white,

              ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(remedial!,
                textScaleFactor: 1.0,
                style: TextStyle(
                  color:  const Color(0xff363636),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Axiforma",
                  fontStyle:  FontStyle.normal,
                  fontSize: 14.sp
              ),),
             // child: Text('hgsddddddddddddddddddd dsghhhhhhhhhhhhhhhhhhhhhhhhhhhhh sdghhhhhhhhhhhhhhhhhhhhhhhhhhhhhhj sjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjd sjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj shgddddddddddddddddddgsdhhhhhhhhhhhh'),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 1.sw - 200,
            height: 50,
            //color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 25,
                    height: 25,
                    decoration: new BoxDecoration(
                        color: Color(0xff24c272),
                        borderRadius: BorderRadius.circular(5)
                    )
                ),

                Text('Remedial Measures',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                  fontFamily: 'Axiforma',
                  color: Color(0xff000000),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,

                ),)
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 1.sw,
            //height: 200,
            //color: Colors.blue,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)
                  ),
                  border: Border.all(
                      color: const Color(0xff707070),
                      width: 1
                  ),
                  color: Colors.white
              ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              //child: Text('jhsdgjghdhsghdsg jhadgshdsh ajghsjdhdsahssdag agdsjjjjjjjjj'),
              child: Text('',style: TextStyle(
                  color:  const Color(0xff363636),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Axiforma",
                  fontStyle:  FontStyle.normal,
                  fontSize: 14.sp
              ),)
            ),
          )
        ],
      ),
    );
  }
}
