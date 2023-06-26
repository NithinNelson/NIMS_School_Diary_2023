import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh - 180,
      //padding: EdgeInsets.only(bottom: 10),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Stack(
              children: [
                Container(
                  width: 1.sw,
                  height: 1.sh - 100,
                  //color: Colors.red,
                ),
                Positioned(
                  top: -10,
                  child: Container(
                    width: 1.sw,

                    // decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //         image: AssetImage('assets/images/about_us_bg.png'))),
                    child: Image.asset(
                      'assets/images/about_us_bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 140,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.only(left: 36, top: 23),
                    width: 1.sw - 40,
                    height: 0.65.sh,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 0),
                            blurRadius: 1,
                            spreadRadius: 0),
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 6,
                            spreadRadius: 0),
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 10),
                            blurRadius: 20,
                            spreadRadius: 0)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //About
                        Text(
                          "About",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: Color(0xff517bfa),
                            fontWeight: FontWeight.w300,
                            fontFamily: "Axiforma",
                            fontStyle: FontStyle.normal,
                            fontSize: 19.sp,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 0.03.sh,
                        ),
                        //Image
                        Image(
                          image: AssetImage('assets/images/Logo2.png'),
                          height: 50,
                          width: 200,
                        ),
                        SizedBox(
                          height: 0.03.sh,
                        ),
                        // Version
                        Opacity(
                          opacity: 0.5,
                          child: Text(
                            "Version",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xff787878),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Axiforma",
                                fontStyle: FontStyle.normal,
                                fontSize: 10.0),
                          ),
                        ),

                        // V. 0.1.01
                        Text(
                          "V. 2.0",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Color(0xff39398b),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Axiforma",
                              fontStyle: FontStyle.normal,
                              fontSize: 11.0),
                        ),
                        SizedBox(
                          height: 0.03.sh,
                        ),
                        // Details
                        Opacity(
                          opacity: 0.5,
                          child: Text(
                            "Details",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xff787878),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Axiforma",
                                fontStyle: FontStyle.normal,
                                fontSize: 10.0),
                          ),
                        ),
                        SizedBox(
                          height: 0.01.sh,
                        ),
                        // A digital school diary that helps to keep updated
                        Text(
                          "A digital school diary that helps  to keep updated about your child.",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Color(0xff787878),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Axiforma",
                              fontStyle: FontStyle.normal,
                              fontSize: 11.0),
                        ),
                        SizedBox(
                          height: 0.015.sh,
                        ),
                        Text(
                          "You will get,",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Color(0xff787878),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Axiforma",
                              fontStyle: FontStyle.normal,
                              fontSize: 11.0),
                        ),
                        SizedBox(
                          height: 0.015.sh,
                        ),
                        Row(
                          children: [
                            Transform.rotate(
                                angle: 4,
                                child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1)),
                                        color: Color(0xfff7993b)))),
                            SizedBox(
                              width: 0.018.sw,
                            ),
                            //Instant attendance notification
                            Text(
                              'Instant attendance notification',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xff787878),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Axiforma",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 11.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.007.sh,
                        ),
                        Row(
                          children: [
                            Transform.rotate(
                                angle: 4,
                                child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1)),
                                        color: Color(0xfff7993b)))),
                            SizedBox(
                              width: 0.018.sw,
                            ),
                            //General circulars in alerts
                            Text(
                              'General circulars in alerts',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xff787878),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Axiforma",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 11.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.007.sh,
                        ),
                        Row(
                          children: [
                            Transform.rotate(
                                angle: 4,
                                child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1)),
                                        color: Color(0xfff7993b)))),
                            SizedBox(
                              width: 0.018.sw,
                            ),
                            //Academic notifications in assignments
                            Text(
                              'Academic notifications in assignments',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xff787878),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Axiforma",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 11.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.007.sh,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Transform.rotate(
                                  angle: 4,
                                  child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(1)),
                                          color: Color(0xfff7993b)))),
                            ),
                            SizedBox(
                              width: 0.018.sw,
                            ),

                            //Academic calendar with events and exam schedules
                            Expanded(
                              child: Text(
                                'Academic calendar with events and exam schedules',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Color(0xff787878),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Axiforma",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 11.0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.007.sh,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Transform.rotate(
                                  angle: 4,
                                  child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(1)),
                                          color: Color(0xfff7993b)))),
                            ),
                            SizedBox(
                              width: 0.018.sw,
                            ),
                            //Pending and paid fee details with option to pay  online and get receipts by email
                            Expanded(
                              child: Text(
                                'Fee status with the option to pay online and get receipts by email',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  color: Color(0xff787878),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Axiforma",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 11.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.007.sh,
                        ),
                        Row(
                          children: [
                            Transform.rotate(
                                angle: 4,
                                child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1)),
                                        color: Color(0xfff7993b)))),
                            SizedBox(
                              width: 0.018.sw,
                            ),
                            //Online exams and its results
                            Text(
                              'Online exams and its results ',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xff787878),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Axiforma",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 11.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.007.sh,
                        ),
                        Row(
                          children: [
                            Transform.rotate(
                                angle: 4,
                                child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1)),
                                        color: Color(0xfff7993b)))),
                            SizedBox(
                              width: 0.018.sw,
                            ),
                            //Report cards
                            Text(
                              'Report cards',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xff787878),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Axiforma",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 11.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
