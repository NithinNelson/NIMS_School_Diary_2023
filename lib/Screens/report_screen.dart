import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Models/calendar_model.dart';
import '../Models/hallTicket_model.dart';
import '../Models/report_model.dart';
import '../Provider/user_provider.dart';
import '../Models/published_exam_model.dart';
import '../Util/color_util.dart';
import '../Util/event.dart';
import '../Models/exam_model.dart';
import '../Util/spinkit.dart';
import '../Widgets/cat4widget.dart';
import '../Widgets/exam_widget.dart';
import '../Widgets/hallTicketWidget.dart';
import '../Widgets/report_widget.dart';
import '../Widgets/upComingExam.dart';
import 'AFL_Screen.dart';

class ReportMainScreen extends StatefulWidget {
  final String? usrId;
  final String? schoolId;
  final String? acadYear;
  final String? curriculumId;
  final String? batchId;
  final String? studId;
  final String? sessionId;
  final String? classId;
  final int? subInd;
  const ReportMainScreen({
    Key? key,
    this.schoolId,
    this.acadYear,
    this.batchId,
    this.classId,
    this.curriculumId,
    this.sessionId,
    this.studId,
    this.usrId,
    this.subInd
  }) : super(key: key);

  @override
  State<ReportMainScreen> createState() => _ReportMainScreenState();
}

class _ReportMainScreenState extends State<ReportMainScreen> {
  var selectedTab =1 ;
  var _isloading = false;
  var _report = Report();
  var _isAfl = false;
  List<ArrayToClient>? _arrayToclient;
  List<Widget> report = [];
  var reporFrom;
  var published;
  var htData = HtModel();
  List<HallTicketData>? hallTickets = [];
  List<Published> pExams = [];
  var pubExams = Published();
  var _calendarFeed = CalendarEvents();
  List<Event> upcomingExam = [];
  List<ExamModel> totalExamList = [];
  List<Color> _clrs = [
    ColorUtil.circularBg,
    ColorUtil.examText,
    ColorUtil.eventYellow,
    ColorUtil.subGold
  ];
  _getReport(String schoolId, String childId, String acadYear) async {
    try {
      setState(() {
        reporFrom = [];
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getPublishedReport(schoolId, childId, acadYear);
      // print(resp.runtimeType);
      report.clear();
      print('report card length ---------->${report.length}');
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        print('its working');
        print(resp['data']['details']['arrayToClient']);
        //  _report = Report.fromJson(resp);
        //print(_report.data!.message);
        //_arrayToclient = _report.data!.details!.arrayToClient;
        reporFrom = resp['data']['details']['arrayToClient'];
        //   resp['data']['details']['arrayToClient'].forEach((one){
        //     print(one);
        //   });
        print(reporFrom);
        //   reporFrom.sort((a,b){
        //       DateTime aa = a['last_updated'];
        //       DateTime bb = b['last_updated'];
        //       return -1 * aa.compareTo(bb);
        //   });
        reporFrom.sort((a, b) {
          DateTime aa = DateFormat('yyyy-M-d').parse(a['last_updated']);
          DateTime bb = DateFormat('yyyy-M-d').parse(b['last_updated']);
          return -1 * aa.compareTo(bb);
        });
        reporFrom!.forEach((one) {
          print(one['name']);
          print(one['last_updated']);
          if (one['name'] == 'CAT4') {
            report.add(CatFour(
              url: one['document'],
              type: 'Cat4',
              childId: widget.usrId,
              title: one['name'].toString(),
              date: one['last_updated'].toString(),
            ));
          } else if (one['name'] == 'ASSET') {
            report.add(CatFour(
              url: one['assets_doc'],
              type: 'Cat4',
              childId: widget.usrId,
              title: one['name'].toString(),
              date: one['last_updated'].toString(),
            ));
          } else {
            report.add(EachReport(
              title: one['name'].toString(),
              date: one['last_updated'].toString(),
              reportConsoleId: one['report_console_id'].toString(),
              studId: widget.studId,
              schoolId: widget.schoolId,
              acdYear: widget.acadYear,
            ));
          }
        });
        //print('length of arr------------->${_arrayToclient!.length}');
        // _arrayToclient!.sort((a,b){
        //   DateTime aa = a.lastUpdated!;
        //   DateTime bb = b.lastUpdated!;
        //   return -1 * aa.compareTo(bb);
        // });
        // _arrayToclient!.forEach((atc) {
        //   report.add(EachReport(
        //     title: atc.name,
        //     date: atc.lastUpdated,
        //   ));
        // });
        // _circularList = Circular.fromJson(resp);
        //print(_circularList.data!.details!.first.title);
        setState(() {
          //_ciculars = _circularList.data!.details!;
        });
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }

  _getExam(String schoolId, String acadYear, String currId, String batchId,
      String stdId, String sessionId, String clsId) async {
    try {
      setState(() {
        // reporFrom = [];
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getExams(
              schoolId, acadYear, currId, batchId, stdId, sessionId, clsId);
      // print(resp.runtimeType);

      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        print('its working');
        print('-------------->${resp['data']['message']}');
        //print('--------------response----------');
        //print(resp['data']['data']['published_completed']);
        published = resp['data']['data']['published_completed'];
        // published.sort((a,b){
        //   DateTime aa = DateTime.parse("${a.publishedDate!.split('-').last}-${a.publishedDate!.split('-')[1]}-${a.publishedDate!.split('-').first}");
        //   DateTime bb = DateTime.parse("${b.publishedDate!.split('-').last}-${b.publishedDate!.split('-')[1]}-${b.publishedDate!.split('-').first}");
        //   return -1 * aa.compareTo(bb);
        // });
        print('length of published--------------->${published.length}');
        if (published == null) {
          published = [];
        } else {
          published.forEach((exam) {
            totalExamList.add(ExamModel(
                type: 'exam',
                activityName: exam['activity_name'],
                markObt: exam['mark'].toString(),
                maxMark: exam['total_mark'].toString(),
                publishedDate: exam['due_date'],
                queId: exam['_id'],
                subName: exam['subject_name'],
                themes: exam['theme_names']));
          });
        }
        totalExamList.sort((a,b){
          DateTime aa = DateTime.parse('${a.publishedDate!.split(' ')[0].split('-').first}-${a.publishedDate!.split(' ')[0].split('-')[1]}-${a.publishedDate!.split(' ')[0].split('-').last}');
          DateTime bb = DateTime.parse('${b.publishedDate!.split(' ')[0].split('-').first}-${b.publishedDate!.split(' ')[0].split('-')[1]}-${b.publishedDate!.split(' ')[0].split('-').last}');;
          return -1 * bb.compareTo(aa);
        });

        //print('length of exam published --------->${published.length}');
        print('total Exam list---------------->$totalExamList');
        print('length of totalExam list---------->${totalExamList.length}');
        // print(resp['data']['details']['arrayToClient']);
        // //  _report = Report.fromJson(resp);
        // //print(_report.data!.message);
        // //_arrayToclient = _report.data!.details!.arrayToClient;
        // reporFrom = resp['data']['details']['arrayToClient'];
        // //   resp['data']['details']['arrayToClient'].forEach((one){
        // //     print(one);
        // //   });
        // print(reporFrom);
        // //   reporFrom.sort((a,b){
        // //       DateTime aa = a['last_updated'];
        // //       DateTime bb = b['last_updated'];
        // //       return -1 * aa.compareTo(bb);
        // //   });
        // reporFrom.sort((a,b){
        //   DateTime aa = DateFormat('yyyy-M-d').parse(a['last_updated']);
        //   DateTime bb = DateFormat('yyyy-M-d').parse(b['last_updated']);
        //   return -1 * aa.compareTo(bb);
        // });
        // reporFrom!.forEach((one) {
        //   print(one['name']);
        //   print(one['last_updated']);
        //   report.add(EachReport(
        //     title: one['name'].toString(),
        //     date: one['last_updated'].toString(),
        //   ));
        // });
        //print('length of arr------------->${_arrayToclient!.length}');
        // _arrayToclient!.sort((a,b){
        //   DateTime aa = a.lastUpdated!;
        //   DateTime bb = b.lastUpdated!;
        //   return -1 * aa.compareTo(bb);
        // });
        // _arrayToclient!.forEach((atc) {
        //   report.add(EachReport(
        //     title: atc.name,
        //     date: atc.lastUpdated,
        //   ));
        // });
        // _circularList = Circular.fromJson(resp);
        //print(_circularList.data!.details!.first.title);
        setState(() {
          //_ciculars = _circularList.data!.details!;
        });
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }

  _getHallTicket(String childId) async {
    try {
      setState(() {
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getHallticket(childId);
      // print(resp.runtimeType);
      //report.clear();
      hallTickets!.clear();
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });

        htData = HtModel.fromJson(resp);
        hallTickets = htData.data!.htData;
        //print('hall ticket length---->${htData.data!.htData!.length}');
        //print('hall ticket runtype---->${htData.data!.htData!.runtimeType}');
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }

  Future<void> _getUpcomingExamss(
      {String? schoolId, String? childId, String? acdYear}) async {
    setState(() {
      // reporFrom = [];

      _isloading = true;
    });
    totalExamList.clear();
    upcomingExam.clear();
    var resp = await Provider.of<UserProvider>(context, listen: false)
        .getCalendarEvents(schoolId!, childId!, acdYear!);
    if (resp['status']['code'] == 200) {
      setState(() {
        _isloading = false;
      });
      print('--------resp-------$resp');
      _calendarFeed = CalendarEvents.fromJson(resp);
      _calendarFeed.data!.data!.calendar!.forEach((element) {
        if (element.date != null) {
          if (element.date!.isAfter(DateTime.now())) {
            if (element.calendar == EventNameElement.EXAM) {
              print('upcoming exam-------->${element.eventName}');
              upcomingExam
                  .add(Event(element.eventName, element.date!, element.calendar));
            }
          }
        }
      });
      if (upcomingExam.isEmpty) return;
      upcomingExam.forEach((upExam) {
        totalExamList.add(ExamModel(
            themes: [],
            subName: '',
            queId: '',
            publishedDate: upExam.date.toString(),
            activityName: upExam.title,
            maxMark: '',
            markObt: '',
            type: 'upcoming'));
      });
      // totalExamList.forEach((element) {
      //   print('------before------------${element.publishedDate}');
      // });
      totalExamList.sort((a,b){
        DateTime aa = DateTime.parse('${a.publishedDate!.split(' ')[0].split('-').first}-${a.publishedDate!.split(' ')[0].split('-')[1]}-${a.publishedDate!.split(' ')[0].split('-').last}');
        DateTime bb = DateTime.parse('${b.publishedDate!.split(' ')[0].split('-').first}-${b.publishedDate!.split(' ')[0].split('-')[1]}-${b.publishedDate!.split(' ')[0].split('-').last}');
        return -1 * bb.compareTo(aa);
      });
      // totalExamList.forEach((element) {
      //   print('------after------------${element.publishedDate}');
      // });
      print('length of upcoming exam----------->${upcomingExam}');
      print('length of totalExam in calEve---------${totalExamList.length}');
    }
  }

  void selectedWid(int actIndex) {
    switch (actIndex) {
      case 1:
        _getReport(widget.schoolId!, widget.studId!, widget.acadYear!);
        break;
      case 2:
        _getUpcomingExamss(
                childId: widget.studId,
                acdYear: widget.acadYear,
                schoolId: widget.schoolId)
            .then((_) => _getExam(
                widget.schoolId!,
                widget.acadYear!,
                widget.curriculumId!,
                widget.batchId!,
                widget.studId!,
                widget.sessionId!,
                widget.classId!));

        break;
      case 3:
        _getHallTicket(widget.studId!);
        break;
      default:
        _getReport(widget.schoolId!, widget.studId!, widget.acadYear!);
        ;
    }
  }
@override
  void initState() {
  //selectedTab = widget.subInd!;
  print('selected tab-----init-->$selectedTab');
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ReportMainScreen oldWidget) {
    //selectedTab = widget.subInd!;
    print('selected tab---did update---->$selectedTab');
    selectedWid(selectedTab);
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    //selectedTab = widget.subInd!;
    print('selected tab-- did change dep----->$selectedTab');
    selectedWid(selectedTab);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return _isAfl
        ? AFLReport()
        : Column(
            children: [
              Container(
                width: 1.sw,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 15),
                // color: Colors.green,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xccaeaed8),
                        offset: Offset(0, 10),
                        blurRadius: 32,
                        spreadRadius: 0)
                  ],
                ),
                child: Row(
                  children: [
                    tabItem('Reports', 1),
                    tabItem('Exams', 2),
                    tabItem('Hall Tickets', 3)
                  ],
                ),
              ),
              Container(
                width: 1.sw,
                height: 1.sh - 200,
                padding: const EdgeInsets.only(bottom: 20),
                color: ColorUtil.mainBg,
                child: _isloading
                    ? ListView.builder(
                        itemCount: (1.sh / 150).round(),
                        itemBuilder: (ctx, _) => skeleton)
                    : (selectedTab == 1)
                        ? report.isNotEmpty
                            ? MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  addAutomaticKeepAlives: true,
                                  children: report,
                                ),
                              )
                            : Center(child: Text('No Reports Available'))
                        : (selectedTab == 2)
                            ? totalExamList.isNotEmpty
                                ? MediaQuery.removePadding(
                  context: context,
                                  removeTop: true,
                                  child: ListView.builder(
                                      itemCount: totalExamList.length,
                                      itemBuilder: (ctx, ind) {
                                        if (totalExamList[ind].type ==
                                            'upcoming') {
                                          return UpcomingExam(
                                            examName:
                                                totalExamList[ind].activityName,
                                            examDate:
                                                totalExamList[ind].publishedDate,
                                            color: _clrs[ind % 3],
                                          );
                                        } else {
                                          return ExamWidget(
                                            schlId: widget.schoolId,
                                            studId: widget.studId,
                                            qpId: totalExamList[ind].queId,
                                            color: _clrs[ind % 3],
                                            date:
                                                totalExamList[ind].publishedDate,
                                            activityName:
                                                totalExamList[ind].activityName,
                                            subName: totalExamList[ind].subName,
                                            themes: totalExamList[ind].themes,
                                            maxMark: totalExamList[ind].maxMark,
                                            markObt: totalExamList[ind].markObt,
                                          );
                                        }
                                      }),
                                )
                                : Center(child: Text('No Exams Available'))
                            //     ? published.isNotEmpty
                            //         ? MediaQuery.removePadding(
                            //             context: context,
                            //             removeTop: true,
                            //             child: ListView.builder(
                            //                 physics: BouncingScrollPhysics(),
                            //                 itemCount: published.length,
                            //                 itemBuilder: (ctx, index) => ExamWidget(
                            //                       schlId: widget.schoolId,
                            //                       studId: widget.studId,
                            //                       qpId: published[index]['_id'],
                            //                       color: _clrs[index % 3],
                            //                       date: published[index]
                            //                           ['due_date'],
                            //                       activityName: published[index]
                            //                           ['activity_name'],
                            //                       subName: published[index]
                            //                           ['subject_name'],
                            //                       themes: published[index]
                            //                           ['theme_names'],
                            //                       markObt: published[index]['mark']
                            //                           .toString(),
                            //                       maxMark: published[index]
                            //                               ['total_mark']
                            //                           .toString(),
                            //                     )),
                            //           )
                            //         : Center(child: Text('No Exams Available'))
                            : (selectedTab == 3)
                                ? hallTickets!.isNotEmpty
                                    ? MediaQuery.removePadding(
                                        context: context,
                                        removeTop: true,
                                        child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: hallTickets!.length,
                                          itemBuilder: (ctx, ind) =>
                                              HallTicketWidget(
                                                  url: hallTickets![ind].pdf,
                                                  date: hallTickets![ind]
                                                      .gneratedOn,
                                                  title: hallTickets![ind]
                                                      .examName!.replaceAll("/", "#").replaceAll("_", "#"),
                                                  childId: widget.studId),
                                        ),
                                      )
                                    : Center(
                                        child:
                                            Text('No Hall Tickets Available'))
                                : Text('kk'),
              )
            ],
          );
  }

  Widget tabItem(String tabName, int activeIndex) => InkWell(
        onTap: () {
          setState(() {
            selectedTab = activeIndex;
            selectedWid(selectedTab);
          });
        },
        child: Container(
          width: 1.sw / 3 - 10,
          height: 50,
          //color: Colors.blue,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                height: 25,
                child: Text(
                  tabName,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: selectedTab == activeIndex
                          ? ColorUtil.tabIndicator
                          : ColorUtil.tabIndicator.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      //fontFamily: "Axiforma",
                      //fontStyle:  FontStyle.normal,
                      fontSize: 16),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              selectedTab == activeIndex
                  ? Container(
                      width: 1.sw / 3,
                      height: 5,
                      decoration: BoxDecoration(
                          color: ColorUtil.tabIndicator,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                    )
                  : Container()
            ],
          ),
        ),
      );
}
