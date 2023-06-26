import 'dart:developer';
import 'package:educare_dubai_v2/Models/timetable_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Provider/user_provider.dart';
import '../Util/spinkit.dart';

class TimeTable extends StatefulWidget {
  final String? schoolId;
  final String? userId;
  final String? sessionId;
  final String? curriculumId;
  final String? classId;
  final String? batchId;
  final String? academicYear;
  const TimeTable(
      {Key? key,
      required this.schoolId,
      required this.userId,
      required this.sessionId,
      required this.curriculumId,
      required this.classId,
      required this.batchId,
      required this.academicYear})
      : super(key: key);

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  var _timetable = TimeTableModel();
  final ScrollController _scrollController = ScrollController();
  bool _loader = false;
  List<Weekdays> _days = [];
  int _today = DateTime.now().weekday;
  int _selectedPeriod = 0;
  List<Periods> _selectedList = [];
  double _width = 0.0;
  double _height = 0.0;

  Future _getTimeTable() async {
    try {
      setState(() {
        _loader = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getTimetable(
              schoolId: widget.schoolId.toString(),
              userId: widget.userId.toString(),
              sessionId: widget.sessionId.toString(),
              curriculumId: widget.curriculumId.toString(),
              classId: widget.classId.toString(),
              batchId: widget.batchId.toString(),
              academicYear: widget.academicYear.toString());
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _loader = false;
        });
        _timetable = TimeTableModel.fromJson(resp);
        setState(() {
          _days = _timetable.data!.timetable!.weekdays!;
        });
        _days.forEach((element) {
          if (element.id == _today) {
            setState(() {
              _selectedList = element.periods!;
            });
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _getTimeTable();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _width = MediaQuery.of(context).size.width;
      _height = MediaQuery.of(context).size.height;
    });
    return _loader
        ? timeTableSkeleton(context)
        : Column(
            children: [
              Container(
                height: 90,
                width: _width,
                margin: const EdgeInsets.only(left: 5, right: 5),
                // color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    radius: const Radius.circular(10),
                    interactive: true,
                    thickness: 2,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _days.length,
                        itemBuilder: (ctx, index) {
                          return weekDays(ctx, index);
                        }),
                  ),
                ),
              ),
              if (_selectedList.isNotEmpty)
                SizedBox(
                  width: _width,
                  height: _height,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _selectedList.length,
                      padding: EdgeInsets.only(bottom: 250.h, top: 10.h),
                      itemBuilder: (ctx, index) {
                        return period(ctx, index);
                      }),
                ),
              if (_selectedList.isEmpty)
                SizedBox(
                  width: _width,
                  height: _height * 0.6,
                  child: const Center(
                    child: Text(
                      "There is no Timetable Available.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          );
  }

  Widget weekDays(ctx, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: InkWell(
        onTap: () {
          setState(() {
            _today = _days[index].id!;
            _selectedList = _days[index].periods!;
          });
        },
        child: Container(
          // height: 10,
          width: 60,
          decoration: BoxDecoration(
            color: _days[index].id! == _today
                ? const Color(0xffffc4dd)
                : const Color(0xffffffff),
            boxShadow: [
              _days[index].id! == _today
                  ? const BoxShadow(
                      color: Color(0x3b000000),
                      offset: Offset(2, 1),
                      blurRadius: 14,
                      spreadRadius: 0)
                  : const BoxShadow()
            ],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xffffffff),
              width: 1,
            ),
          ),
          child: Center(
              child: Text(
            _days[index].name!.substring(0, 3),
            style: const TextStyle(
                color: Color(0xcc34378b),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal),
          )),
        ),
      ),
    );
  }

  Widget period(ctx, index) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  // alignment: Alignment.centerLeft,
                  width: _width * 0.2,
                  height: 50,
                  child: Center(
                    child: Text(_selectedList[index].startTime!,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          textStyle: const TextStyle(
                              color: Color(0xcc858585),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0),
                        )),
                  )),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: colorConvert(_selectedList[index].subjectColor!, 0)
                      .withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                height: _selectedPeriod == _selectedList[index].periodNumber!
                    ? 120
                    : 50,
                width: _width * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              _selectedPeriod == 0
                                  ? _selectedList[index].teacherName != ""
                                      ? _selectedPeriod =
                                          _selectedList[index].periodNumber!
                                      : _selectedPeriod = 0
                                  : _selectedPeriod = 0;
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: colorConvert(
                                    _selectedList[index].subjectColor!, 0),
                                border: _selectedList[index].nonteachingPeriod!
                                    ? Border.all(
                                        color: const Color(0xff7b9ad0),
                                        width: 1)
                                    : Border.all(
                                        color: const Color(0xffffffff),
                                        width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                              width: _width * 0.7,
                              height: 50,
                              child: Text(
                                  _selectedList[index].subjectName! == ""
                                      ? _selectedList[index].name!
                                      : _selectedList[index].subjectName!,
                                  style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    textStyle: TextStyle(
                                        color: (colorConvert(
                                                    _selectedList[index]
                                                        .subjectColor!,
                                                    0) ==
                                                Colors.white)
                                            ? const Color(0xff7b9ad0)
                                            : Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0),
                                  )))),
                      if (_selectedPeriod == _selectedList[index].periodNumber!)
                        // if (_isExpand)
                        Container(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          width: _width * 0.7,
                          height: 50,
                          child: Text(
                            _selectedList[index].teacherName!,
                            style: GoogleFonts.openSans(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Color colorConvert(String color, int i) {
    if (color == "") {
      return Colors.white;
    }
    color = color.replaceAll("#", "");
    if (i == 0) {
      return Color(int.parse("0xFF${color.toUpperCase()}"));
    } else if (i == 1) {
      return Color(int.parse("0x99${color.toUpperCase()}"));
    } else {
      return Colors.white;
    }
  }
}
