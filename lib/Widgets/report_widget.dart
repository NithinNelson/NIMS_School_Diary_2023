import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Provider/user_provider.dart';
import '../Util/color_util.dart';
import '../Util/spinkit.dart';
import 'detailedReport.dart';

class EachReport extends StatefulWidget {
  final String? schoolId;
  final String? studId;
  final String? acdYear;
  final String? title;
  final String? date;
  final String? reportConsoleId;
  const EachReport(
      {Key? key,
      this.date,
      this.title,
      this.reportConsoleId,
      this.studId,
      this.schoolId,
      this.acdYear})
      : super(key: key);

  @override
  State<EachReport> createState() => _EachReportState();
}

class _EachReportState extends State<EachReport> {
  var _isloading = false;
  var isCalled = false;
  var _isFetched = false;
  Map<String, dynamic> detailedMark = {};
  List<String> subject = [];
  var _isExpanded = false;
  _getReport(String consoleId, String schlId, String stdId, bool mndet) async {
    try {
      setState(() {
        //reporFrom = [];
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getDetailedReport(consoleId, schlId, stdId, mndet);
      // print(resp.runtimeType);
      //report.clear();
      // print('report card length ---------->${report.length}');
      print('staus code-------------->${resp['status']['code']}');
      print(resp['data']['details']['response']['all_subjects'].runtimeType);
      //detailedMark = resp['data']['details']['response']['all_subjects'];

      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
          isCalled = true;
          detailedMark = resp['data']['details']['response']['all_subjects'];
          print('detailed mark length--------${detailedMark.length}');
          detailedMark.forEach((key, value) {
            subject.add(key);
          });
          _isExpanded = !_isExpanded;
        });
      }
    } catch (e) {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (!isCalled) {
                _getReport(widget.reportConsoleId!, widget.schoolId!,
                    widget.studId!, true);
              } else {
                _isExpanded = !_isExpanded;
              }
            });
          },
          child: Container(
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
                Container(
                  // color: Colors.grey,
                  width: 200.w,
                  child: Text(
                    widget.title!,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        color: ColorUtil.tabIndicator,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Axiforma",
                        // fontStyle:  FontStyle.normal,
                        fontSize: 18.sp),
                  ),
                ),
                Container(
                  width: 82.w,
                  // color: Colors.red,
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
                            fontSize: 16),
                      ),
                      _isExpanded
                          ? Icon(Icons.arrow_drop_up_outlined)
                          : Icon(Icons.arrow_drop_down)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        _isloading
            ? skeleton
            : _isExpanded
                ? DetailedReport(
                    subjects: subject,
                    detailedList: detailedMark,
                    rcId: widget.reportConsoleId,
                    schlId: widget.schoolId,
                    stdId: widget.studId,
                    title: widget.title!.replaceAll("/", "#").replaceAll("_", "#"),
                  )
                : Container()
      ],
    );
  }
}
