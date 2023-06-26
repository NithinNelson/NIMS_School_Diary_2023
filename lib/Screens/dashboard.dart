import 'dart:convert';
import 'dart:io';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import '../Models/user_model.dart';
import '../Models/dashboard_model.dart';
import '../Provider/user_provider.dart';
import '../Util/color_util.dart';

class DashboardScreen extends StatefulWidget {
  final Function dashSwitching;
  final String parentId;
  final String childId;
  final String photoId;
  //final List<StudentDetail> studentsList;
  const DashboardScreen(
      {Key? key,
      required this.parentId,
      required this.childId,
      required this.dashSwitching,
      required this.photoId})
      : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  var _activeindex = 0;
  var _isloading = false;
  var _dashboardfeed = Dashboard();
  var isDashboardEmpty = ' ';
  List<DashboardItem> _items = [];
  DateFormat _circFormatter = DateFormat('dd MMMM yyyy, hh:mm a');
  DateFormat _examformatter = DateFormat('dd MMMM yyyy');
  Animation<Offset>? _slideTransition;
  AnimationController? _controller;
  var fcmToken;

  _cacheAdding() async {
    var isCacheExist =
        await APICacheManager().isAPICacheKeyExist(widget.childId);
    if (!isCacheExist) {
      _dashBoardFeed(widget.parentId, widget.childId);
    } else {
      print('cache already exist');
      var CacheData = await APICacheManager().getCacheData(widget.childId);
      var caheAPi = json.decode(CacheData.syncData);
      _dashboardfeed = Dashboard.fromJson(caheAPi);
      print(_dashboardfeed.data!.data!.first.type);
      setState(() {
        _items = _dashboardfeed.data!.data!;
      });

      // for fixing the student present or absent status showing container at the top of the screen
      //start
      var attendance;
      for (int i = 0; i < _items.length; i++) {
        if (_items[i].type == "Attendance") {
          attendance = _items[i];
          _items.removeAt(i);
          _items.insert(0, attendance);
        }
      }
      // end

      if (_items.isEmpty) {
        isDashboardEmpty = 'No dashboard feed';
      }
      _controller!.forward();
    }
  }

  _dashBoardFeed(String parentId, String studId) async {
    try {
      setState(() {
        _isloading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getDashboardfeed(parentId, studId);
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isloading = false;
        });
        APICacheDBModel cacheDBModel =
            APICacheDBModel(key: widget.childId, syncData: json.encode(resp));
        await APICacheManager().addCacheData(cacheDBModel);
        _dashboardfeed = Dashboard.fromJson(resp);
        print(_dashboardfeed.data!.data!.first.type);
        setState(() {
          _items = _dashboardfeed.data!.data!;
        });

        // for fixing the student present or absent status showing container at the top of the screen
        //start
        var attendance;
        for (int i = 0; i < _items.length; i++) {
          if (_items[i].type == "Attendance") {
            attendance = _items[i];
            _items.removeAt(i);
            _items.insert(0, attendance);
          }
        }
        // end

        if (_items.isEmpty) {
          isDashboardEmpty = 'No dashboard feed';
        }
        _controller!.forward();
      }
    } catch (e) {
      print(e);
    }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print('state = $state');
  // }
  @override
  void initState() {
    //WidgetsBinding.instance.addObserver(this);
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _slideTransition =
        _controller!.drive(Tween(begin: Offset(1.5, 0), end: Offset(0, 0)));
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('dashboard didchangede');
    _cacheAdding();
    // TODO: implement didChangeDependencies
    //_dashBoardFeed(widget.parentId, widget.childId);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    print('dashboard didupdate');
    _cacheAdding();
    // _dashBoardFeed(widget.parentId, widget.childId);
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // CarouselSlider.builder(
        //   itemCount: widget.studentsList.length,
        //   itemBuilder: (context, index, realIndex) {
        //     final name = widget.studentsList[index].name;
        //     final classofstd = widget.studentsList[index].studentDetailClass;
        //     final batchofstd = widget.studentsList[index].batch;
        //     final imgUrl =
        //         'https://teamsqa3000.educore.guru${widget.studentsList[index].photo}';
        //     return nameCard(
        //         studentName: name.toString(),
        //         photourl: imgUrl,
        //         grade: batchofstd.toString(),
        //         classofstd: classofstd.toString());
        //   },
        //   options: CarouselOptions(
        //       height: 170,
        //       //enlargeCenterPage: true,
        //       viewportFraction: 1,
        //       enableInfiniteScroll: false,
        //       onPageChanged: (index, reason) async {
        //         setState(() {
        //           _activeindex = index;
        //           print(widget.parentId);
        //           print(widget.studentsList[index].userId);
        //         });
        //         _dashBoardFeed(widget.parentId,
        //             widget.studentsList[index].userId.toString());
        //       }),
        // ),
        // _isloading
        //     ? shimmerLoader()
        //     : Container(
        //         child: Text(_dashboardfeed.data!.data!.first.type.toString()),
        //       )
        // Container(
        //   height: 1.sh /2 + 80,
        //   child: ListView(
        //     children: [
        //       circular(),
        //       exam(),
        //       report(),
        //       assignment()
        //     ],
        //   ),
        // )
        _isloading
            ? shimmerLoader()
            : _items.isEmpty
                ? SizedBox(
                    width: 1.sw,
                    height: 1.sh - 380,
                    child: Center(child: Text('$isDashboardEmpty')))
                : RefreshIndicator(
                    onRefresh: () =>
                        _dashBoardFeed(widget.parentId, widget.childId),
                    child: Container(
                      height: 1.sh - 370,
                      // color: Colors.red,
                      //padding: EdgeInsets.only(bottom: 35),
                      //margin: EdgeInsets.only(bottom: 20),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            //shrinkWrap: true,
                            itemCount: _items.length,
                            itemBuilder: (ctx, index) {
                              if (_items[index].type == 'Attendance') {
                                return Container(
                                  width: 1.sw,
                                  height: 80,
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 15),
                                  padding: EdgeInsets.symmetric(horizontal: 5),

                                  //color: Colors.red,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color(0xccaeaed8),
                                          offset: Offset(0, 10),
                                          blurRadius: 32,
                                          spreadRadius: 0)
                                    ],
                                    color: const Color(0xfff5f5f5),
                                  ),

                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              //  color: Colors.red,
                                              decoration: BoxDecoration(
                                                  // color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: CircleAvatar(
                                                radius: 28,
                                                backgroundColor:
                                                    Color(0xff8829e1),
                                                child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor: Colors.white,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                60)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: widget.photoId,
                                                      width: 45,
                                                      height: 45,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              Image.asset(
                                                        'assets/images/userImage.png',
                                                        width: 45,
                                                        height: 45,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        'assets/images/userImage.png',
                                                        width: 45,
                                                        height: 45,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 5,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                    color: (_items[index]
                                                                .title!
                                                                .split(
                                                                    ' ')[_items[
                                                                            index]
                                                                        .title!
                                                                        .split(
                                                                            ' ')
                                                                        .length -
                                                                    2]
                                                                .toUpperCase() ==
                                                            'PRESENT')
                                                        ? ColorUtil.green
                                                        : Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60)),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Row(
                                          children: [
                                            //for(int i=0;i<_items[index].title!.split(' ').length - 5;i++)
                                            AutoSizeText(
                                              '${_items[index].title!.split(' ').first} is ',
                                              maxLines: 2,
                                              textScaleFactor: 1,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Row(
                                              children: [
                                                AutoSizeText(
                                                  _items[index]
                                                      .title!
                                                      .split(' ')[_items[index]
                                                              .title!
                                                              .split(' ')
                                                              .length -
                                                          2]
                                                      .toCapitalCase(),
                                                  textScaleFactor: 1,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: (_items[index]
                                                                  .title!
                                                                  .split(
                                                                      ' ')[_items[
                                                                              index]
                                                                          .title!
                                                                          .split(
                                                                              ' ')
                                                                          .length -
                                                                      2]
                                                                  .toUpperCase() ==
                                                              'PRESENT')
                                                          ? ColorUtil.green
                                                          : Colors.red),
                                                ),
                                                Text(
                                                  ' Today',
                                                  textScaleFactor: 1,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                )
                                              ],
                                            )
                                            // SizedBox(
                                            //     width: 1.sw-120,
                                            //     height: 40,
                                            //     child: AutoSizeText(_items[index].title!.split(' ')[_items[index].title!.split(' ').length - 2],maxLines:2,style: TextStyle(fontSize: 14),)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                              if (_items[index].type == 'Exam') {
                                return exam(
                                  photoUrl: widget.photoId,
                                  title: _items[index].academic,
                                  status: _items[index].status,
                                  desc: _items[index].title,
                                  date: _items[index].examDate,
                                );
                              }
                              if (_items[index].type == 'Circular') {
                                return circular(
                                    photoUrl: widget.photoId,
                                    id: _items[index].circularId,
                                    title: _items[index].title,
                                    desc: _items[index].description,
                                    date: _items[index].feedDate);
                              }
                              if (_items[index].type == 'Report_card') {
                                return report(
                                    photoUrl: widget.photoId,
                                    title: _items[index].title,
                                    date: _items[index].feedDate);
                              }
                              if (_items[index].type == 'Assignment') {
                                return assignment(
                                    photoUrl: widget.photoId,
                                    id: _items[index].assignId,
                                    title: _items[index].title,
                                    date: _items[index].feedDate);
                              }
                              return Container();
                            }),
                      ),
                    ),
                  )
      ],
    );
  }

  // Widget nameCard(
  //         {required String studentName,
  //         required String photourl,
  //         required String grade,
  //         required String classofstd}) =>
  //     Container(
  //       width: 1.sw - 40,
  //       height: 200,
  //       padding: EdgeInsets.symmetric(vertical: 15),
  //       //margin: EdgeInsets.symmetric(horizontal: 20),
  //       margin: EdgeInsets.only(bottom: 5),
  //       decoration: BoxDecoration(
  //         boxShadow: [
  //           BoxShadow(
  //               color: Colors.black12,
  //               offset: Offset(0, 0),
  //               blurRadius: 1,
  //               spreadRadius: 0),
  //           BoxShadow(
  //               color: Colors.black12,
  //               offset: Offset(0, 2),
  //               blurRadius: 6,
  //               spreadRadius: 0),
  //           // BoxShadow(
  //           //     color: Colors.black12,
  //           //     offset: Offset(0, 10),
  //           //     blurRadius: 20,
  //           //     spreadRadius: 0)
  //         ],
  //         borderRadius: BorderRadius.circular(20),
  //         color: Colors.white,
  //       ),
  //       child: Column(
  //         children: [
  //           CircleAvatar(
  //             radius: 28,
  //             backgroundColor: Color(0xff8829e1),
  //             child: CircleAvatar(
  //               radius: 25,
  //               backgroundColor: Colors.white,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.all(Radius.circular(60)),
  //                 child: CachedNetworkImage(
  //                   imageUrl: photourl,
  //                   placeholder: (context, url) => SizedBox(
  //                     width: 20,
  //                     height: 20,
  //                     child: CircularProgressIndicator(),
  //                   ),
  //                   errorWidget: (context, url, error) => Image.asset(
  //                     'assets/images/userImage.png',
  //                     width: 45,
  //                     height: 45,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           AutoSizeText(
  //             studentName,
  //             maxLines: 1,
  //             style: TextStyle(
  //                 color: Color(0xff8829e1),
  //                 fontFamily: 'Axiforma',
  //                 fontSize: 14.sp,
  //                 fontWeight: FontWeight.w500),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 'Grade',
  //                 style: TextStyle(
  //                     color: Color(0xffcd758e),
  //                     fontFamily: 'Axiforma',
  //                     fontSize: 10.sp,
  //                     fontWeight: FontWeight.w500),
  //               ),
  //               SizedBox(
  //                 width: 5,
  //               ),
  //               Text(
  //                 classofstd,
  //                 style: TextStyle(
  //                     color: Color(0xffcd758e),
  //                     fontFamily: 'Axiforma',
  //                     fontSize: 10.sp,
  //                     fontWeight: FontWeight.w500),
  //               ),
  //               Text(
  //                 grade,
  //                 style: TextStyle(
  //                     color: Color(0xffcd758e),
  //                     fontFamily: 'Axiforma',
  //                     fontSize: 10.sp,
  //                     fontWeight: FontWeight.w500),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 6,
  //           ),
  //           buildIndicator()
  //         ],
  //       ),
  //     );
  //
  // Widget buildIndicator() => AnimatedSmoothIndicator(
  //       activeIndex: _activeindex,
  //       count: widget.studentsList.length,
  //       effect: SlideEffect(dotWidth: 9, dotHeight: 9),
  //     );

  Widget shimmerLoader() => Shimmer.fromColors(
        baseColor: Color(0xffcda4de),
        highlightColor: Color(0xffc3d0be),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: 1.sw,
          height: 1.sh - 400,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        ),
      );
  //------------Circular Widget---------------------//
  Widget circular(
          {String? desc,
          String? photoUrl,
          String? title,
          DateTime? date,
          String? id}) =>
      InkWell(
        onTap: () {
          print('cirid in ontap-----$id');
          widget.dashSwitching(1, id, true);
          //  print('circular');
        },
        child: SlideTransition(
          position: _slideTransition!,
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 2),
            decoration: BoxDecoration(
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.black12,
              //       offset: Offset(0, 0),
              //       blurRadius: 1,
              //       spreadRadius: 0),
              //   BoxShadow(
              //       color: Colors.black12,
              //       offset: Offset(0, 2),
              //       blurRadius: 6,
              //       spreadRadius: 0),
              //   // BoxShadow(
              //   //     color: Colors.black12,
              //   //     offset: Offset(0, 10),
              //   //     blurRadius: 20,
              //   //     spreadRadius: 0)
              // ],
              boxShadow: [
                BoxShadow(
                    color: const Color(0xccaeaed8),
                    offset: Offset(0, 10),
                    blurRadius: 32,
                    spreadRadius: 0)
              ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // width: 110,
                      height: 28,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: ColorUtil.circularBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: ColorUtil.circularText, width: 1.2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.campaign_outlined,
                            color: ColorUtil.circularText,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Circular',
                            textScaleFactor: 0.95,
                            style: TextStyle(color: ColorUtil.circularText),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5, height: 5,),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          imageUrl: photoUrl.toString(),
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Container(
                        width: 1.sw - 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.toString(),
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: ColorUtil.circularText,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              desc.toString(),
                              textScaleFactor: 0.9,
                            ),
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Published Date',
                      textScaleFactor: 0.95,
                      style: datelabelStyle,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: ColorUtil.dateColor.withOpacity(0.5),
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      _circFormatter.format(date!),
                      textScaleFactor: 0.9,
                      style: dateTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  //------------Report Widget---------------------//
  Widget report(
          {String? type, String? photoUrl, String? title, DateTime? date}) =>
      InkWell(
        onTap: () {
          widget.dashSwitching(5, 'dd', true);
          // print('report');
        },
        child: SlideTransition(
          position: _slideTransition!,
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 2),
            //margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: const Color(0xccaeaed8),
                    offset: Offset(0, 10),
                    blurRadius: 32,
                    spreadRadius: 0),
                BoxShadow(
                  color: Colors.white,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ),
              ],
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.black12,
              //       offset: Offset(0, 0),
              //       blurRadius: 1,
              //       spreadRadius: 0),
              //   BoxShadow(
              //       color: Colors.black12,
              //       offset: Offset(0, 2),
              //       blurRadius: 6,
              //       spreadRadius: 0),
              //   // BoxShadow(
              //   //     color: Colors.black12,
              //   //     offset: Offset(0, 10),
              //   //     blurRadius: 20,
              //   //     spreadRadius: 0)
              // ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // width: 110,
                      height: 28,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: ColorUtil.reportBg,
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: ColorUtil.reportText, width: 1.2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pie_chart,
                            color: ColorUtil.reportText,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Report',
                            textScaleFactor: 0.95,
                            style: TextStyle(color: ColorUtil.reportText),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5, height: 5,),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          imageUrl: photoUrl.toString(),
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.sw - 150,
                      child: Text(
                        title.toString(),
                        textScaleFactor: 1.0,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Published Date',
                      textScaleFactor: 1.0,
                      style: datelabelStyle,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: ColorUtil.dateColor.withOpacity(0.5),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      _circFormatter.format(date!),
                      textScaleFactor: 1.0,
                      style: dateTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  //------------Assignment Widget---------------------//
  Widget assignment(
          {String? type,
          String? photoUrl,
          String? title,
          DateTime? date,
          String? id}) =>
      InkWell(
        onTap: () {
          widget.dashSwitching(2, id, true);
          // print('assignment');
        },
        child: SlideTransition(
          position: _slideTransition!,
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 2),
            //margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: const Color(0xccaeaed8),
                    offset: Offset(0, 10),
                    blurRadius: 32,
                    spreadRadius: 0)
              ],
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.black12,
              //       offset: Offset(0, 0),
              //       blurRadius: 1,
              //       spreadRadius: 0),
              //   BoxShadow(
              //       color: Colors.black12,
              //       offset: Offset(0, 2),
              //       blurRadius: 6,
              //       spreadRadius: 0),
              //   // BoxShadow(
              //   //     color: Colors.black12,
              //   //     offset: Offset(0, 10),
              //   //     blurRadius: 20,
              //   //     spreadRadius: 0)
              // ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // width: 130,
                      height: 28,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: ColorUtil.assignmentBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: ColorUtil.assignmentText, width: 1.2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            color: ColorUtil.assignmentText,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Assignment',
                            textScaleFactor: 0.95,
                            style: TextStyle(color: ColorUtil.assignmentText),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5, height: 5,),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          imageUrl: photoUrl.toString(),
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1.sw - 150,
                      child: Text(
                        title.toString(),
                        textScaleFactor: 1.0,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Published Date',
                      textScaleFactor: 1.0,
                      style: datelabelStyle,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: ColorUtil.dateColor.withOpacity(0.5),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      _circFormatter.format(date!),
                      textScaleFactor: 1.0,
                      style: dateTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  //--------------Exam Widget-----------------------//
  Widget exam(
          {String? photoUrl,
          String? title,
          String? desc,
          String? status,
          DateTime? date}) =>
      InkWell(
        onTap: () {
          widget.dashSwitching(5, 'dd', true);
          //print('exam');
        },
        child: SlideTransition(
          position: _slideTransition!,
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 2),
            //margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: const Color(0xccaeaed8),
                    offset: Offset(0, 10),
                    blurRadius: 32,
                    spreadRadius: 0)
              ],
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.black12,
              //       offset: Offset(0, 0),
              //       blurRadius: 1,
              //       spreadRadius: 0),
              //   BoxShadow(
              //       color: Colors.black12,
              //       offset: Offset(0, 2),
              //       blurRadius: 6,
              //       spreadRadius: 0),
              //   // BoxShadow(
              //   //     color: Colors.black12,
              //   //     offset: Offset(0, 10),
              //   //     blurRadius: 20,
              //   //     spreadRadius: 0)
              // ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // width: 90,
                      height: 28,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: ColorUtil.examBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: ColorUtil.examText, width: 1.2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.border_color_outlined,
                            color: ColorUtil.examText,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Exam',
                            textScaleFactor: 0.95,
                            style: TextStyle(color: ColorUtil.examText),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        // width: 90,
                        height: 25,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: _color(status!.toLowerCase()),
                            // (status!.toLowerCase() == 'absent')
                            //     ? Colors.red
                            //     : Colors.lightBlue.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: _boxShadowColor(status!.toLowerCase()),
                                  // (status!.toLowerCase() == 'absent')
                                  //     ? ColorUtil.circularRed
                                  //     : Colors.lightBlue.withOpacity(0.7),
                                  blurRadius: 2,
                                  spreadRadius: 1)
                            ]
                            // border: Border.all(
                            //     color: (status!.toLowerCase() == 'absent')
                            //         ? ColorUtil.circularRed
                            //         : ColorUtil.examText,
                            //     width: 1.2),
                            ),
                        child: Center(
                            child: Text(
                          status.toString(),
                          textScaleFactor: 0.8,
                          style: TextStyle(color: Colors.white),
                        ))),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: CachedNetworkImage(
                          imageUrl: photoUrl.toString(),
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/userImage.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Container(
                        width: 1.sw - 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.toString(),
                              textScaleFactor: 0.98,
                              style: TextStyle(
                                  color: ColorUtil.examText,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              desc.toString(),
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Exam Date',
                      textScaleFactor: 0.95,
                      style: datelabelStyle,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: ColorUtil.dateColor.withOpacity(0.5),
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      _circFormatter.format(date!),
                      textScaleFactor: 0.9,
                      style: dateTextStyle,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  var dateTextStyle = TextStyle(
      color: ColorUtil.dateColor.withOpacity(0.6),
      fontSize: 11,
      fontWeight: FontWeight.w600);
  var datelabelStyle = TextStyle(
      color: ColorUtil.dateColor.withOpacity(0.5),
      fontSize: 11,
      fontStyle: FontStyle.italic);

  Color _color(String status) {
    switch(status) {
      case 'absent': return Colors.red;
      case 'waiting for result': return Colors.yellow.shade600;
      case 'published': return Colors.green.shade600;
      case 'scheduled': return Colors.lightBlue.withOpacity(0.5);
      default: return Colors.deepPurpleAccent;
    }
  }

  Color _boxShadowColor(String status) {
    switch(status) {
      case 'absent': return ColorUtil.circularRed;
      case 'waiting for result': return Colors.yellow.shade600.withOpacity(0.9);
      case 'published': return Colors.green.shade600;
      case 'scheduled': return Colors.lightBlue.withOpacity(0.7);
      default: return Colors.deepPurpleAccent.shade400;
    }
  }
}
