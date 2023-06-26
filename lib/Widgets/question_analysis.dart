import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../Util/color_util.dart';

class QuestionAnalysis extends StatefulWidget {
  final String? question;
  final String? questType;
  final String? rightAnswer;
  final String? studAnswer;
  final String? torf;
  final String? studScore;
  final String? maxScore;
  final String? studPerc;
  final String? maxPerc;
  const QuestionAnalysis({
    Key? key,
    this.studScore,
    this.studAnswer,
    this.rightAnswer,
    this.questType,
    this.question,
    this.maxScore,
    this.torf,
    this.studPerc,
    this.maxPerc,
  }) : super(key: key);

  @override
  State<QuestionAnalysis> createState() => _QuestionAnalysisState();
}

class _QuestionAnalysisState extends State<QuestionAnalysis>
    with TickerProviderStateMixin {
  var _isExpanded = false;
  var _height = 260.0;
  Duration _myduration = Duration(milliseconds: 800);
  var _doneDur = false;
  // Animation<double>? _myAnimation;
  // AnimationController? _controller;
  Future _complete() async {
    // Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        _doneDur = true;
      });
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 200),
    // );
    //
    // _myAnimation = CurvedAnimation(
    //     curve: Curves.linear,
    //     parent: _controller!
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // _isExpanded = !_isExpanded;
            // print(_isExpanded);
            // if (_isExpanded) {
            //   //  _controller!.forward();
            //   setState(() {
            //     _height = 300.0 + (widget.rightAnswer!.length);
            //   });
            //   _complete();
            // } else {
            //   // _controller!.reverse();
            //   setState(() {
            //     _height = 260.0;
            //     _doneDur = false;
            //   });
            // }
          },
          child: Container(
            // duration: _myduration,
            // curve: Curves.fastOutSlowIn,
            width: 1.sw,
            // height: _height +
            //     (widget.question!.length - 50) +
            //     (widget.studAnswer!.length+30),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.only(top: 30, bottom: 50, left: 10, right: 10),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Text(
                    widget.questType!,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      color: Color(0xff979797),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      // color: Colors.red,
                      decoration: BoxDecoration(
                          color: ColorUtil.circularRed,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(child: Text('Q',  textScaleFactor: 1.0,)),
                    ),
                    Container(
                      width: 1.sw - 90,
                      //height: 70,
                      //color: Colors.blue,
                      child: HtmlWidget(
                        widget.question!,
                        // webView: true,
                        // child: AutoSizeText(
                        //   widget.question!,
                        //   textScaleFactor: 1.0,
                        //   style: TextStyle(
                        //       color: const Color(0xff363636),
                        //       fontWeight: FontWeight.w400,
                        //       fontFamily: "Axiforma",
                        //       fontStyle: FontStyle.normal,
                        //       fontSize: 18),
                        // ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                  indent: 50,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      // color: Colors.red,
                      // decoration: BoxDecoration(color: ColorUtil.circularRed,borderRadius: BorderRadius.circular(10)),
                      // child: Center(child: Text('Q')),
                    ),
                    Container(
                      width: 1.sw - 90,
                      //height: 70,
                      //color: Colors.blue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Response',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              color: Color(0xff1eb1ae),
                              fontSize: 18,
                              fontFamily: 'Axiforma',
                            ),
                          ),
                          Text(
                            widget.studAnswer!,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              color: Color(0xff818181),
                              fontSize: 18,
                              fontFamily: 'Axiforma',
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                (_doneDur)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            // color: Colors.red,
                            decoration: BoxDecoration(
                                color: ColorUtil.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text('A',  textScaleFactor: 1.0,)),
                          ),
                          Container(
                            width: 1.sw - 90,
                            //height: 70,
                            //color: Colors.blue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Correct Answer',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    color: ColorUtil.green,
                                    fontSize: 18,
                                    fontFamily: 'Axiforma',
                                  ),
                                ),
                                Text(
                                  widget.rightAnswer!,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    color: Color(0xff818181),
                                    fontSize: 18,
                                    fontFamily: 'Axiforma',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                //SizedBox(height: 6,),

              ],
            ),
          ),
        ),
        Positioned(
            right: 20,
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: ColorUtil.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //SizedBox(height: 5,),
                      Text(
                        '${widget.studPerc!} %'
                        ,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: ColorUtil.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Axiforma",
                            fontStyle: FontStyle.normal,
                            fontSize: 10.0),
                      ),
                      // Container(
                      //   width: 40,
                      //   height: 3,
                      //   color: Colors.white,
                      // ),
                      //Divider(thickness: 2,indent: 5,endIndent: 5,),
                      Text(
                        'Student',
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: ColorUtil.white,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Axiforma",
                            //fontStyle:  FontStyle.normal,
                            fontSize: 10),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 70,
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: ColorUtil.markYellow,
                      borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //SizedBox(height: 5,),
                        Text(
                          '${widget.maxPerc!} %'
                          ,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: ColorUtil.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Axiforma",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                        ),
                        // Container(
                        //   width: 40,
                        //   height: 3,
                        //   color: Colors.white,
                        // ),
                        //Divider(thickness: 2,indent: 5,endIndent: 5,),
                        Text(
                          'Class',
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: ColorUtil.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Axiforma",
                              //fontStyle:  FontStyle.normal,
                              fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
        Positioned(
          bottom: 80,
          child: InkWell(
            onTap: () {
              _isExpanded = !_isExpanded;
              print(_isExpanded);
              if (_isExpanded) {
                //  _controller!.forward();
                setState(() {
                  _height = 300.0 + (widget.rightAnswer!.length);
                });
                _complete();
              } else {
                // _controller!.reverse();
                setState(() {
                  _height = 260.0;
                  _doneDur = false;
                });
              }
            },
            child: Row(
              children: [
                SizedBox(
                  width: 1.sw - 70,
                ),
                Transform.rotate(
                  angle: _doneDur ? (180 * math.pi / 180) : 0,
                  child: Icon(Icons.arrow_drop_down, size: 30),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
