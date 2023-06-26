import 'dart:collection';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Models/calendar_model.dart';
import '../Provider/user_provider.dart';
import '../Util/color_util.dart';
import '../Util/event.dart';

class CalendarScreen extends StatefulWidget {
  final String? schoolId;
  final String? childId;
  final String? acdYr;
  const CalendarScreen({Key? key, this.schoolId, this.childId, this.acdYr})
      : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  // DateTime _selectedDay = DateTime.now();
  // DateTime _focusedDay = DateTime.now();
  //late final ValueNotifier<List<Event?>> _selectedEvents;
  var _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  var _isloading = false;
  var _calendarFeed = CalendarEvents();
  var totalDays = 0;
  var totalPresent = 0;
  var totalAbsent = 0;
  //var calEventSource;
  List<Event> addedEv = [];
  List<Event> upcomingEv = [];
  List<Event> upcomingExam = [];
  Map<DateTime, List<Event>> evMap = {};
  List<CalendarClass> caEvents = [];
  //List<CalendarClass> caEventRe = [];
  //var selectedDate = DateFormat.yMMMd(DateTime.now());
  var calEvents = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  var slctdDt = DateTime.now();
  calenderEvents(String schoolId, String childId, String acdYear) async {
    try {
      setState(() {
        evMap.clear();
        calEvents.clear();
        //addedEv.clear();
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getCalendarEvents(schoolId, childId, acdYear);
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      print('event map length---------->${evMap.length}');
      //print('aded event array length------->${addedEv.length}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        print(resp['data']['data']['calendar']);
        _calendarFeed = CalendarEvents.fromJson(resp);
        print(_calendarFeed.data!.data!.fullattendance!.total);
        print(_calendarFeed.data!.data!.calendar!.first.calendar);
        //caEvents = _calendarFeed.data!.data!.calendar!;
        print('cal events---------->$caEvents');
        _calendarFeed.data!.data!.calendar!.forEach((ev) {
          // print('each id------>${ev.id}');
          // print('each id runtime type------>${ev.id.runtimeType}');

          // caEvents.removeWhere((e) => (e.id == ev.id));
          caEvents.add(ev);
        });
        caEvents.forEach((element) {
          print('-----tebhq-------${element.eventName}');
        });
        // caEvents.forEach((eve) {
        //   print('event id---------->${eve.id}');
        // });
        // caEvents.forEach((even) {
        //   for(int i = 0; i< caEvents.length; i++){
        //     if(even.id.toString() == caEvents[i].id.toString()){
        //       continue;
        //     }else{
        //       caEventRe.add(caEvents[i]);
        //     }
        //   }
        // });

        caEvents.forEach((element) {
          //addedEv.add(Event(element.eventName.toString(), element.date!,element.calendar));
          //print(element.calendar);

          if (element.calendar != EventNameElement.PRESENT) {
            if (element.date != null) {
              evMap.addAll({
                DateTime.utc(element.date!.year, element.date!.month,
                    element.date!.day): []
              });
            }
          }

          setState(() {});

          // evMap.addAll({
          //   DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day):[Event('dem', DateTime.now(), 'Present')]
          // });
          //calEventSource = Map.fromIterable(iterable)
        });
        // print('event map length after iteration---------->${evMap.length}');
        // print('aded event array length after iteration------->${addedEv.length}');
        caEvents.forEach((element) {
          if (element.calendar != EventNameElement.PRESENT) {
            if (element.date != null) {
              if (evMap.containsKey(DateTime.utc(element.date!.year,
                  element.date!.month, element.date!.day))) {
                evMap.update(
                    DateTime.utc(element.date!.year, element.date!.month,
                        element.date!.day),
                    (value) => List.from(value)
                      ..add(Event(element.eventName.toString(), element.date!,
                          element.calendar!)));
              }
            }
          }
        });
        caEvents.forEach((element) {
          if (element.date != null) {
            if (element.date!.isAfter(DateTime.now())) {
              // print('date--------${DateFormat('EEEE').format(element.date!)}');
              // if((DateFormat('EEEE').format(element.date!).toString() == 'Saturday')||(DateFormat('EEEE').format(element.date!).toString() == 'Sunday'))
              // return;
              if (element.calendar == EventNameElement.EVENTS) {
                upcomingEv.add(
                    Event(element.eventName, element.date!, element.calendar));
              }
              if (element.calendar == EventNameElement.EXAM) {
                print('upcoming exam-------->${element.eventName}');
                upcomingExam.add(
                    Event(element.eventName, element.date!, element.calendar));
              }
            }
          }
        });
        upcomingEv.sort((a, b) {
          // DateTime aa = DateTime.parse("${a.date!.split('-').last}-${a.date!.split('-')[1]}-${a.date!.split('-').first}");
          // DateTime bb = DateTime.parse("${b.date!.split('-').last}-${b.date!.split('-')[1]}-${b.date!.split('-').first}");
          DateTime aa = a.date;
          DateTime bb = b.date;
          return -1 * bb.compareTo(aa);
        });
        upcomingExam.sort((a, b) {
          // DateTime aa = DateTime.parse("${a.date!.split('-').last}-${a.date!.split('-')[1]}-${a.date!.split('-').first}");
          // DateTime bb = DateTime.parse("${b.date!.split('-').last}-${b.date!.split('-')[1]}-${b.date!.split('-').first}");
          DateTime aa = a.date;
          DateTime bb = b.date;
          return -1 * bb.compareTo(aa);
        });
        print('event map length after iteration---------->${evMap.length}');
        if (evMap.isNotEmpty) {
          setState(() {
            calEvents.addAll(evMap);
          });
        }

        setState(() {
          //
          // final  calEventSource = Map.fromIterable(
          //     List.generate(_calendarFeed.data!.data!.calendar!.length, (index) => index),
          //       key: (item) => DateTime.utc(_calendarFeed.data!.data!.calendar![item].date!.year, _calendarFeed.data!.data!.calendar![item].date!.month, _calendarFeed.data!.data!.calendar![item].date!.day),
          //       value: (item) => addedEv..add(Event(_calendarFeed.data!.data!.calendar![item].eventName)));
          //print('elements in evmap=${evMap.length}');
          // evMap.forEach((key, value) {
          //   print('$key ---------- ${value.length}');
          // });
          // calEventSource.forEach((key, value) {
          //   print('$key----------->${value}');
          // });
          //   if(calEventSource != null && calEventSource.isNotEmpty)
          //     calEvents.addAll(calEventSource);
        });

        //  print(_dashboardfeed.data!.data!.first.type);
        //   setState(() {
        //     _items = _dashboardfeed.data!.data!;
        //   });
        // evMap.forEach((key, value) {
        //   print('$key-------------->${value.length}');
        // });
      }
      _selectedDay = _focusedDay;
      // print('selected day ---------->${_selectedDay}');
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
      setState(() {
        _getEventsForDay(_selectedDay!);
      });
      _calendarFeed.data!.data!.monthattendance!.forEach((atten) {
        // print(atten.id);
        // print(atten.id.runtimeType);
        // print('leave -----${atten.leave!}');
        if (_selectedDay!.month != int.parse(atten.id!)) return;
        //print('condition satisfied');

        setState(() {
          // print(atten.absent);
          // print(atten.present);
          // print(atten.total);
          print('leave -----${atten.leave!}');
          totalAbsent = atten.absent! + atten.leave!;
          totalPresent = atten.present!;
          totalDays = atten.total!;
        });
      });
    } catch (e) {
      _selectedDay = _focusedDay;
      print(e);
    }
  }

  @override
  void didUpdateWidget(covariant CalendarScreen oldWidget) {
    print('did update called');
    print(_focusedDay);
    caEvents.clear();
    evMap.clear();
    upcomingEv.clear();
    upcomingExam.clear();
    print('length of event map--------->${evMap.length}');
    calenderEvents(widget.schoolId!, widget.childId!, widget.acdYr!);

    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    calenderEvents(widget.schoolId!, widget.childId!, widget.acdYr!);

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print('init state called');
    evMap.clear();
    // _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents != null ? _selectedEvents.dispose() : _selectedEvents;
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    //return kEvents[day] ?? [];
    return calEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        // slctdDt = _selectedDay!;
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return _isloading
        ? shimmerLoader()
        : Container(
            width: 1.sw,
            height: 1.sh - 150,
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 20),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  TableCalendar<Event?>(
                    calendarBuilders: CalendarBuilders(
                        singleMarkerBuilder: (ctx, date, event) {
                      if (event!.eventName == EventNameElement.HOLIDAY) {
                        final text = DateFormat.E().format(date);
                        return Center(
                            child: Text(
                          'H',
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        ));
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: event!.eventName == EventNameElement.ABSENT
                                  ? ColorUtil.absentIndiColor
                                  : event.eventName == EventNameElement.EVENTS
                                      ? ColorUtil.eventIndiColor
                                      : event.eventName == EventNameElement.EXAM
                                          ? ColorUtil.examIndiColor
                                          : Colors.black), //Change color
                          width: 5.0,
                          height: 5.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 1.5, vertical: 5),
                        );
                      }
                    }),
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    calendarFormat: _calendarFormat,
                    rangeSelectionMode: _rangeSelectionMode,
                    eventLoader: _getEventsForDay,
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    // calendarStyle: CalendarStyle(
                    //   // Use `CalendarStyle` to customize the UI
                    //   outsideDaysVisible: false,
                    // ),
                    onDaySelected: _onDaySelected,
                    onRangeSelected: _onRangeSelected,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        totalAbsent = 0;
                        totalPresent = 0;
                        totalDays = 0;
                      });
                      _focusedDay = focusedDay;
                      print(focusedDay);
                      print(focusedDay.month.runtimeType);
                      _calendarFeed.data!.data!.monthattendance!
                          .forEach((atten) {
                        print(atten.id);
                        print(atten.id.runtimeType);
                        print('year-------->${focusedDay.year}');
                        print('year from API----------->${atten.year}');
                        if (focusedDay.month != int.parse(atten.id!) ||
                            !DateTime.now().isAfter(focusedDay)) return;
                        print('condition satisfied');
                        setState(() {
                          print(atten.absent);
                          print(atten.present);
                          print(atten.total);
                          totalAbsent = atten.absent! + atten.leave!;
                          totalPresent = atten.present!;
                          totalDays = atten.total!;
                        });
                      });
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      // decoration: BoxDecoration(
                      //   color: Color(0xff34378b)
                      // )
                      titleTextStyle: TextStyle(
                        fontFamily: 'Axiforma',
                        color: ColorUtil.tabIndicator,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      leftChevronIcon: Icon(
                        Icons.arrow_left_outlined,
                        color: ColorUtil.tabIndicator,
                      ),
                      rightChevronIcon: Icon(
                        Icons.arrow_right_outlined,
                        color: ColorUtil.tabIndicator,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyle(
                        fontFamily: 'Axiforma',
                        color: ColorUtil.tabIndicator.withOpacity(0.5),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      weekdayStyle: TextStyle(
                        fontFamily: 'Axiforma',
                        color: ColorUtil.tabIndicator.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      holidayTextStyle: TextStyle(
                          fontFamily: 'Axiforma',
                          color: ColorUtil.absentIndiColor,
                          fontSize: 19),
                      defaultTextStyle: TextStyle(
                          fontFamily: 'Axiforma',
                          color: ColorUtil.calendarFont,
                          fontSize: 16),
                      weekendTextStyle: TextStyle(
                          fontFamily: 'Axiforma',
                          color: ColorUtil.absentIndiColor,
                          fontSize: 16),
                    ),
                  ),
                  eventIndicator(),
                  attendanceBar(),
                  eventTabBar(_tabController),
                  _selectedEvents != null
                      ? eventTabBarView(context, _tabController)
                      : Container()
                ],
              ),
            ),
            // child: Column(
            //   children: [
            //     TableCalendar<Event?>(
            //       firstDay: kFirstDay,
            //       lastDay: kLastDay,
            //       focusedDay: _focusedDay,
            //       selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            //       rangeStartDay: _rangeStart,
            //       rangeEndDay: _rangeEnd,
            //       calendarFormat: _calendarFormat,
            //       rangeSelectionMode: _rangeSelectionMode,
            //       eventLoader: _getEventsForDay,
            //       startingDayOfWeek: StartingDayOfWeek.monday,
            //       calendarStyle: CalendarStyle(
            //         // Use `CalendarStyle` to customize the UI
            //         outsideDaysVisible: false,
            //       ),
            //       onDaySelected: _onDaySelected,
            //       onRangeSelected: _onRangeSelected,
            //       onFormatChanged: (format) {
            //         if (_calendarFormat != format) {
            //           setState(() {
            //             _calendarFormat = format;
            //           });
            //         }
            //       },
            //       onPageChanged: (focusedDay) {
            //         _focusedDay = focusedDay;
            //       },
            //     ),
            //     const SizedBox(height: 8.0),
            //     Expanded(
            //       child: ValueListenableBuilder<List<Event?>>(
            //         valueListenable: _selectedEvents,
            //         builder: (context, value, _) {
            //           return ListView.builder(
            //             itemCount: value.length,
            //             itemBuilder: (context, index) {
            //               return Container(
            //                 margin: const EdgeInsets.symmetric(
            //                   horizontal: 12.0,
            //                   vertical: 4.0,
            //                 ),
            //                 decoration: BoxDecoration(
            //                   border: Border.all(),
            //                   borderRadius: BorderRadius.circular(12.0),
            //                 ),
            //                 child: ListTile(
            //                   onTap: () => print('${value[index]}'),
            //                   title: Text('${value[index]}'),
            //                 ),
            //               );
            //             },
            //           );
            //         },
            //       ),
            //     ),
            //   ],
            // ),
          );
  }

  Widget shimmerLoader() => Shimmer.fromColors(
        baseColor: ColorUtil.shimmerBaseColor,
        highlightColor: ColorUtil.shimmerHglt,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              width: 1.sw,
              height: 1.sh - 450,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              width: 1.sw,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              width: 1.sw,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      );
  Widget eventIndicator() => Container(
        width: 1.sw,
        height: 25,
        //margin: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
        margin: EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 0),
        //color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            eachIndicator('Events', ColorUtil.eventIndiColor),
            eachIndicator('Exams', ColorUtil.examIndiColor),
            eachIndicator('Absent', ColorUtil.absentIndiColor),
            eachIndicator('Holiday', ColorUtil.absentIndiColor)
          ],
        ),
      );
  Widget eachIndicator(String indicatorName, Color indicatorColor) => Container(
        // width: 80,
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (indicatorName == 'Holiday')
                ? Text(
                    'H',
                    style: TextStyle(color: indicatorColor),
                  )
                : CircleAvatar(
                    radius: 4,
                    backgroundColor: indicatorColor,
                  ),
            SizedBox(
              width: 10,
            ),
            Text(
              indicatorName,
              textScaleFactor: 1.0,
              style: TextStyle(
                color: ColorUtil.indicatorBlack,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      );
  Widget attendanceBar() => Container(
        width: 1.sw,
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 20),
        //color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            attendanceIndicator(
                totalDays, 'Days Total', ColorUtil.totalDaysIndicator),
            attendanceIndicator(totalPresent, 'Days Present', ColorUtil.green),
            attendanceIndicator(
                totalAbsent, 'Days Absent', ColorUtil.absentIndiColor)
          ],
        ),
      );
  Widget attendanceIndicator(int nos, String attIndicator, Color indColor) =>
      Container(
        width: 100,
        height: 80,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: indColor, borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                '$nos',
                textScaleFactor: 1.0,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    //fontFamily: "Axiforma",
                    //fontStyle:  FontStyle.normal,
                    fontSize: 20),
              )),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
                width: 50,
                child: Text(
                  attIndicator,
                  maxLines: 2,
                  textScaleFactor: 1.0,
                  softWrap: true,
                  style: TextStyle(
                    color: ColorUtil.indicatorBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ))
          ],
        ),
      );
  Widget eventTabBar(TabController tab) => Container(
        width: 1.sw,
        height: 30,
        child: TabBar(
            isScrollable: true,
            //padding: EdgeInsets.symmetric(horizontal: 10),
            //   indicator: UnderlineTabIndicator(
            //       borderSide: BorderSide(width: 5.0),
            //       insets: EdgeInsets.symmetric(horizontal:16.0)
            //   ),
            //indicatorSize: TabBarIndicatorSize.tab,
            controller: tab,
            labelColor: ColorUtil.tabIndicator,
            labelStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Axiforma'),
            indicatorColor: ColorUtil.tabIndicator,
            unselectedLabelColor: ColorUtil.tabUnselected.withOpacity(0.36),
            tabs: [
              Container(
                width: 100,
                child: Tab(
                  text:
                      '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                ),
              ),
              Container(
                  width: 1.sw / 3 + 10,
                  child: Tab(
                    text: 'Upcoming Events',
                  )),
              Container(
                  width: 1.sw / 3 + 10,
                  child: Tab(
                    text: 'Upcoming Exams',
                  ))
            ]),
      );

  Widget eventTabBarView(BuildContext ctx, TabController ctrl) => Container(
        width: 1.sw,
        height: 300,
        child: TabBarView(
          controller: ctrl,
          children: [
            Container(
              height: 150,
              //color: Colors.red,
              child: ValueListenableBuilder<List<Event?>>(
                  valueListenable: _selectedEvents,
                  builder: (ctx, value, _) {
                    return value.length == 0
                        ? Center(child: Text('No Events and Exams'))
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: value.length,
                            itemBuilder: (ct, i) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                width: 1.sw,
                                //height: 100,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: value[i]!.eventName ==
                                                EventNameElement.EVENTS
                                            ? ColorUtil.eventYellow
                                            : value[i]!.eventName ==
                                                    EventNameElement.EXAM
                                                ? ColorUtil.examIndiColor
                                                : value[i]!.eventName ==
                                                        EventNameElement.HOLIDAY
                                                    ? ColorUtil.absentIndiColor
                                                    : value[i]!.eventName ==
                                                            EventNameElement
                                                                .ABSENT
                                                        ? ColorUtil
                                                            .absentIndiColor
                                                        : ColorUtil.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 100,
                                        // margin: const EdgeInsets.symmetric(
                                        //   horizontal: 12.0,
                                        //   vertical: 12.0,
                                        // ),
                                        decoration: BoxDecoration(
                                          color: value[i]!.eventName ==
                                                  EventNameElement.EVENTS
                                              ? ColorUtil.eventYellow
                                                  .withOpacity(0.25)
                                              : value[i]!.eventName ==
                                                      EventNameElement.EXAM
                                                  ? ColorUtil.examIndiColor
                                                      .withOpacity(0.25)
                                                  : value[i]!.eventName ==
                                                          EventNameElement
                                                              .HOLIDAY
                                                      ? ColorUtil
                                                          .absentIndiColor
                                                          .withOpacity(0.25)
                                                      : value[i]!.eventName ==
                                                              EventNameElement
                                                                  .ABSENT
                                                          ? ColorUtil
                                                              .absentIndiColor
                                                              .withOpacity(0.25)
                                                          : ColorUtil.white,
                                          // border: Border.all(),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: ListTile(
                                          // onTap: () => print('${value[index]}'),
                                          // subtitle: ,
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text('${value[i]!.eventName}'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    top: 20,
                                                    right: 5,
                                                    bottom: 0),
                                                child: Text(
                                                  //'dd MMMM yyyy, hh:mm a'
                                                  '${DateFormat('dd MMMM yyyy').format(value[i]!.date)}',
                                                  style: TextStyle(
                                                      color: value[i]!
                                                                  .eventName ==
                                                              EventNameElement
                                                                  .EVENTS
                                                          ? ColorUtil
                                                              .eventYellow
                                                          : value[i]!.eventName ==
                                                                  EventNameElement
                                                                      .EXAM
                                                              ? ColorUtil
                                                                  .examIndiColor
                                                              : value[i]!.eventName ==
                                                                      EventNameElement
                                                                          .HOLIDAY
                                                                  ? ColorUtil
                                                                      .absentIndiColor
                                                                  : value[i]!.eventName ==
                                                                          EventNameElement
                                                                              .ABSENT
                                                                      ? ColorUtil
                                                                          .absentIndiColor
                                                                      : ColorUtil
                                                                          .white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      //fontFamily: "Axiforma",
                                                      // fontStyle:  FontStyle.normal,
                                                      fontSize: 14.sp),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    top: 5,
                                                    right: 5,
                                                    bottom: 5),
                                                child: AutoSizeText(
                                                  '${value[i]!.title}',
                                                  maxLines: 3,
                                                  maxFontSize: 16,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xff4c4c4c),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      //fontFamily: "Axiforma",
                                                      // fontStyle:  FontStyle.normal,
                                                      fontSize: 20.sp),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                  }),
            ),
            Container(
              height: 150,
              child: upcomingEv.length == 0
                  ? Center(child: Text('No Upcoming Events'))
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: upcomingEv.length,
                      itemBuilder: (ctx, i) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: ColorUtil.eventYellow,
                                    // color: upcomingEv[i].eventName ==
                                    //         EventNameElement.EVENTS
                                    //     ? ColorUtil.eventYellow
                                    //     : upcomingEv[i].eventName ==
                                    //             EventNameElement.EXAM
                                    //         ? ColorUtil.examIndiColor
                                    //         : upcomingEv[i].eventName ==
                                    //                 EventNameElement.HOLIDAY
                                    //             ? ColorUtil.absentIndiColor
                                    //             : upcomingEv[i].eventName ==
                                    //                     EventNameElement.ABSENT
                                    //                 ? ColorUtil.absentIndiColor
                                    //                 : ColorUtil.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 100,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: ColorUtil.eventYellow
                                          .withOpacity(0.25),
                                      // color: upcomingEv[i].eventName ==
                                      //         EventNameElement.EVENTS
                                      //     ? ColorUtil.eventYellow
                                      //         .withOpacity(0.25)
                                      //     : upcomingEv[i].eventName ==
                                      //             EventNameElement.EXAM
                                      //         ? ColorUtil.examIndiColor
                                      //             .withOpacity(0.25)
                                      //         : upcomingEv[i].eventName ==
                                      //                 EventNameElement.HOLIDAY
                                      //             ? ColorUtil.absentIndiColor
                                      //                 .withOpacity(0.25)
                                      //             : upcomingEv[i].eventName ==
                                      //                     EventNameElement
                                      //                         .ABSENT
                                      //                 ? ColorUtil
                                      //                     .absentIndiColor
                                      //                     .withOpacity(0.25)
                                      //                 : ColorUtil.white,
                                      // border: Border.all(),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              top: 20,
                                              right: 5,
                                              bottom: 0),
                                          child: Text(
                                            //'dd MMMM yyyy, hh:mm a'
                                            '${DateFormat('dd MMMM yyyy').format(upcomingEv[i].date)}',
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: ColorUtil.eventYellow,
                                                // color: upcomingEv[i].eventName ==
                                                //         EventNameElement.EVENTS
                                                //     ? ColorUtil.eventYellow
                                                //     : upcomingEv[i].eventName ==
                                                //             EventNameElement.EXAM
                                                //         ? ColorUtil.examIndiColor
                                                //         : upcomingEv[i]
                                                //                     .eventName ==
                                                //                 EventNameElement
                                                //                     .HOLIDAY
                                                //             ? ColorUtil
                                                //                 .absentIndiColor
                                                //             : upcomingEv[i]
                                                //                         .eventName ==
                                                //                     EventNameElement
                                                //                         .ABSENT
                                                //                 ? ColorUtil
                                                //                     .absentIndiColor
                                                //                 : ColorUtil.white,
                                                fontWeight: FontWeight.w400,
                                                //fontFamily: "Axiforma",
                                                // fontStyle:  FontStyle.normal,
                                                fontSize: 14.sp),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              top: 5,
                                              right: 5,
                                              bottom: 5),
                                          child: AutoSizeText(
                                            '${upcomingEv[i].title}',
                                            //textScaleFactor: 1.0,
                                            maxLines: 3,
                                            maxFontSize: 16,
                                            style: TextStyle(
                                                color: const Color(0xff4c4c4c),
                                                fontWeight: FontWeight.w500,
                                                //fontFamily: "Axiforma",
                                                // fontStyle:  FontStyle.normal,
                                                fontSize: 20.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
            ),
            Container(
              height: 150,
              child: upcomingExam.length == 0
                  ? Center(child: Text('No Upcoming Exams'))
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: upcomingExam.length,
                      itemBuilder: (ctx, i) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: ColorUtil.examIndiColor,
                                    // color: upcomingExam[i].eventName ==
                                    //         EventNameElement.EVENTS
                                    //     ? ColorUtil.eventYellow
                                    //     : upcomingExam[i].eventName ==
                                    //             EventNameElement.EXAM
                                    //         ? ColorUtil.examIndiColor
                                    //         : upcomingExam[i].eventName ==
                                    //                 EventNameElement.HOLIDAY
                                    //             ? ColorUtil.absentIndiColor
                                    //             : upcomingExam[i].eventName ==
                                    //                     EventNameElement.ABSENT
                                    //                 ? ColorUtil.absentIndiColor
                                    //                 : ColorUtil.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 100,
                                    //margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                    decoration: BoxDecoration(
                                      color: ColorUtil.examIndiColor
                                          .withOpacity(0.25),
                                      // color: upcomingExam[i].eventName ==
                                      //         EventNameElement.EVENTS
                                      //     ? ColorUtil.eventYellow
                                      //         .withOpacity(0.25)
                                      //     : upcomingExam[i].eventName ==
                                      //             EventNameElement.EXAM
                                      //         ? ColorUtil.examIndiColor
                                      //             .withOpacity(0.25)
                                      //         : upcomingExam[i].eventName ==
                                      //                 EventNameElement.HOLIDAY
                                      //             ? ColorUtil.absentIndiColor
                                      //                 .withOpacity(0.25)
                                      //             : upcomingExam[i].eventName ==
                                      //                     EventNameElement
                                      //                         .ABSENT
                                      //                 ? ColorUtil
                                      //                     .absentIndiColor
                                      //                     .withOpacity(0.25)
                                      //                 : ColorUtil.white,
                                      // border: Border.all(),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      physics: NeverScrollableScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                top: 20,
                                                right: 5,
                                                bottom: 0),
                                            child: Text(
                                              '${DateFormat('dd MMMM yyyy').format(upcomingExam[i].date)}',
                                              style: TextStyle(
                                                  color:
                                                      ColorUtil.examIndiColor,
                                                  // color: upcomingExam[i]
                                                  //             .eventName ==
                                                  //         EventNameElement.EVENTS
                                                  //     ? ColorUtil.eventYellow
                                                  //     : upcomingExam[i].eventName ==
                                                  //             EventNameElement.EXAM
                                                  //         ? ColorUtil.examIndiColor
                                                  //         : upcomingExam[i]
                                                  //                     .eventName ==
                                                  //                 EventNameElement
                                                  //                     .HOLIDAY
                                                  //             ? ColorUtil
                                                  //                 .absentIndiColor
                                                  //             : upcomingExam[i]
                                                  //                         .eventName ==
                                                  //                     EventNameElement
                                                  //                         .ABSENT
                                                  //                 ? ColorUtil
                                                  //                     .absentIndiColor
                                                  //                 : ColorUtil.white,
                                                  fontWeight: FontWeight.w400,
                                                  //fontFamily: "Axiforma",
                                                  // fontStyle:  FontStyle.normal,
                                                  fontSize: 14.sp),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                top: 5,
                                                bottom: 5,
                                                right: 5),
                                            child: AutoSizeText(
                                              '${upcomingExam[i].title}',
                                              maxLines: 3,
                                              maxFontSize: 16,
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xff4c4c4c),
                                                  fontWeight: FontWeight.w500,
                                                  //fontFamily: "Axiforma",
                                                  // fontStyle:  FontStyle.normal,
                                                  fontSize: 20.sp),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
            ),
          ],
        ),
      );
}
