import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get_ip_address/get_ip_address.dart';
import '../Models/notif_model.dart';
import '../Provider/user_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Models/user_model.dart';
import '../Screens/dashboard.dart';
import '../Screens/circular_screen.dart';
import '../Util/api_constants.dart';
import '../Util/color_util.dart';
import 'about_screen.dart';
import 'assignment_screen.dart';
import 'calendar_screen.dart';
import 'downloads.dart';
import 'fee_screen.dart';
import 'login_screen.dart';
import 'notif_screen.dart';
import 'profile_screen.dart';
import 'report_screen.dart';
import 'reset_password.dart';
import 'ticket_screen.dart';
import 'timetable_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  var _userdata = Users();
  List<Map<String, Object>> _pages = [];
  int _seletedPageIndex = 0;
  List<StudentDetail> _students = [];
  List<Map> students = [];
  var _activeindex = 0;
  // var userId;
  var _selectedChild;
  String? circularId;
  var childIndex;
  bool isClicked = false;
  var photoUrl = '';
  var schoolLogo = '';
  var schoolId = '';
  var fcmToken;
  var _notif = Notifications();
  List<AllNotification> _allNotif = [];
  List<int> _items = [];
  int? notifNo;
  fbToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
  }

  _getNotif(String parentId) async {
    try {
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getNotification(parentId);
      _notif = Notifications.fromJson(resp);
      print(_notif.status!.message);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        _notif.data!.details!.allNotifications!.forEach((notific) {
          _allNotif.add(
            AllNotification(
              date: notific.date,
              genDate: notific.genDate,
              iconType: notific.iconType,
              id: notific.id,
              msg: notific.msg,
              recipient: notific.recipient,
              references: notific.references,
              senderId: notific.senderId,
              status: notific.status,
              type: notific.type,
              updatedBy: notific.updatedBy,
              updatedOn: notific.updatedOn,
            ),
          );
        });
        print('length of notifications ------>${_allNotif.length}');
        setState(() {
          notifNo = _allNotif.length;
        });
      } else {
        print('notification Api not loaded');
      }
    } catch (e) {
      print('Exception in notif---------->$e');
    }
  }

  setupNotification(String email) {
    print('user email id---->$email');
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      print('fcm response-----------$fcmToken');
      // TODO: If necessary send token to application server.
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .tokenUpdate(email, fcmToken);
      print('fcm response-----------$resp');
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
      print(err);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    //setupNotification(_userdata.data!.data![0].username!);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    print('did update widget called');
    setupNotification(_userdata.data!.data![0].username!);
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.paused) {
      print('App paused');
    } else if (state == AppLifecycleState.resumed) {
      print('app resumed');
      setupNotification(_userdata.data!.data![0].username!);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeDependencies() {
    isClicked = false;
    print('did change dependencies called');
    _userdata = ModalRoute.of(context)!.settings.arguments as Users;
    print(_userdata.data!.data![0].username);
    print(
        'https://alpha.docme.cloud/schooldiary-logo/${_userdata.data!.data![0].schoolId}.png');
    _selectedChild = _userdata.data!.data![0].studentDetails!.first.userId!;
    photoUrl = _userdata.data!.data![0].studentDetails!.first.photo ?? ' ';
    photoUrl = '${ApiConstants.downloadUrl}$photoUrl';
    schoolLogo = _userdata.data!.data![0].schoolLogo!;
    schoolId = _userdata.data!.data![0].schoolId!;
    _getNotif(_userdata.data!.data![0].id!);
    print('school logo ------------>$schoolLogo');
    print('photo url -----------$photoUrl');
    //_rabbitMQAPI();
    setupNotification(_userdata.data!.data![0].username!);
    _pages = [
      {
        'page': DashboardScreen(
          photoId: photoUrl,
          dashSwitching: switchingFrDash,
          parentId: _userdata.data!.data![0].id.toString(),
          //studentsList: _userdata.data!.data![0].studentDetails!,
          childId: _userdata.data!.data![0].studentDetails!.first.userId!,
        ),
        'title': 'dashboard',
        'centre': false,
        'isPopup': false
      },
      {
        'page': CircularScreen(
          // isClicked: false,
          //  circularId: null,
          parentId: _userdata.data!.data![0].id.toString(),
          childId: _userdata.data!.data![0].studentDetails!.first.userId,
          acadYear: _userdata.data!.data![0].studentDetails!.first.academicYear,
        ),
        'title': 'Circular',
        'centre': true,
        'isPopup': true
      },
      {
        'page': AssignmentScreen(
          parentId: _userdata.data!.data![0].id.toString(),
          childId: _userdata.data!.data![0].studentDetails!.first.userId,
          acadYear: _userdata.data!.data![0].studentDetails!.first.academicYear,
        ),
        'title': 'Assignment',
        'centre': true,
        'isPopup': true
      },
      {
        'page': CalendarScreen(
          schoolId: _userdata.data!.data![0].schoolId,
          childId: _userdata.data!.data![0].studentDetails!.first.userId,
          acdYr: _userdata.data!.data![0].studentDetails!.first.academicYear,
        ),
        'title': 'Calendar',
        'centre': true,
        'isPopup': true
      },
      {
        'page': FeeScreen(
          admnNo:
              _userdata.data!.data![0].studentDetails!.first.admissionNumber,
          dataToken: _userdata.data!.data![0].schoolDataToken ?? "null",
          parentEmail: _userdata.data!.data![0].username,
        ),
        'title': 'Fees',
        'centre': true,
        'isPopup': true
      },
      {
        'page': ReportMainScreen(
          subInd: 1,
          usrId: _userdata.data!.data![0].id,
          schoolId: _userdata.data!.data![0].schoolId,
          studId: _userdata.data!.data![0].studentDetails!.first.userId,
          acadYear: _userdata.data!.data![0].studentDetails!.first.academicYear,
          batchId: _userdata.data!.data![0].studentDetails!.first.batchId,
          classId: _userdata.data!.data![0].studentDetails!.first.classId,
          curriculumId:
              _userdata.data!.data![0].studentDetails!.first.curriculumId,
          sessionId: _userdata.data!.data![0].studentDetails!.first.sessionId,
        ),
        'title': 'Assessments',
        'centre': true,
        'isPopup': true
      },
      {
        'page': AboutScreen(),
        'title': 'About',
        'centre': true,
        'isPopup': false
      },
      {
        'page': DownloadScreen(),
        'title': 'Downloads',
        'centre': true,
        'isPopup': false
      },
      {
        'page': ProfileScreen(
          userPhoto: _userdata.data!.data![0].image,
          address: _userdata.data!.data![0].address,
          emailId: _userdata.data!.data![0].username,
          mobileNo: _userdata.data!.data![0].mobile,
          username: _userdata.data!.data![0].name,
          studentList: _userdata.data!.data![0].studentDetails,
        ),
        'title': 'My Profile',
        'centre': true,
        'isPopup': false
      },
      {
        'page': TicketScreen(),
        'title': 'Ticket',
        'centre': true,
        'isPopup': false
      },
      {
        'page': ResetPassword(email: _userdata.data!.data![0].username),
        'title': 'Reset Password',
        'centre': true,
        'isPopup': false
      },
      {
        'page': TimeTable(
          schoolId: _userdata.data!.data![0].schoolId,
          userId: _userdata.data!.data![0].studentDetails!.first.userId,
          sessionId: _userdata.data!.data![0].studentDetails!.first.sessionId,
          curriculumId: _userdata.data!.data![0].studentDetails!.first.curriculumId,
          classId: _userdata.data!.data![0].studentDetails!.first.classId,
          batchId: _userdata.data!.data![0].studentDetails!.first.batchId,
          academicYear: _userdata.data!.data![0].studentDetails!.first.academicYear,
        ),
        'title': 'Time Table',
        'centre': true,
        'isPopup': true
      }
    ];
    _students = _userdata.data!.data![0].studentDetails!;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  _pageSwitching(int pageIndex) {
    setState(() {
      _activeindex = pageIndex;
      _selectedChild = _students[pageIndex].userId!;
      // photoUrl = _students[pageIndex].photo?? ' ';
      photoUrl = '${ApiConstants.downloadUrl}${_students[pageIndex].photo}';
      print('photo url in popup----$photoUrl');
      _pages = [
        {
          'page': DashboardScreen(
            photoId: photoUrl,
            dashSwitching: switchingFrDash,
            parentId: _userdata.data!.data![0].id.toString(),
            // studentsList: _userdata.data!.data![0].studentDetails!,
            childId: _students[pageIndex].userId!,
          ),
          'title': 'dashboard',
          'centre': false,
          'isPopup': false
        },
        {
          'page': CircularScreen(
            //  isClicked: isClicked,
            // circularId: circularId,
            parentId: _userdata.data!.data![0].id.toString(),
            childId: _students[pageIndex].userId,
            acadYear: _students[pageIndex].academicYear,
          ),
          'title': 'Circular',
          'centre': true,
          'isPopup': true
        },
        {
          'page': AssignmentScreen(
            parentId: _userdata.data!.data![0].id.toString(),
            childId: _students[pageIndex].userId,
            acadYear: _students[pageIndex].academicYear,
          ),
          'title': 'Assignment',
          'centre': true,
          'isPopup': true
        },
        {
          'page': CalendarScreen(
            schoolId: _userdata.data!.data![0].schoolId,
            childId: _students[pageIndex].userId,
            acdYr: _students[pageIndex].academicYear,
          ),
          'title': 'Calendar',
          'centre': true,
          'isPopup': true
        },
        {
          'page': FeeScreen(
            admnNo: _students[pageIndex].admissionNumber,
            dataToken: _userdata.data!.data![0].schoolDataToken ?? "null",
          ),
          'title': 'Fees',
          'centre': true,
          'isPopup': true
        },
        {
          'page': ReportMainScreen(
            usrId: _userdata.data!.data![0].id,
            schoolId: _userdata.data!.data![0].schoolId,
            studId: _students[pageIndex].userId,
            acadYear: _students[pageIndex].academicYear,
            batchId: _students[pageIndex].batchId,
            classId: _students[pageIndex].classId,
            curriculumId: _students[pageIndex].curriculumId,
            sessionId: _students[pageIndex].sessionId,
          ),
          'title': 'Assessments',
          'centre': true,
          'isPopup': true
        },
        {
          'page': AboutScreen(),
          'title': 'About',
          'centre': true,
          'isPopup': false
        },
        {
          'page': DownloadScreen(),
          'title': 'Downloads',
          'centre': true,
          'isPopup': false
        },
        {
          'page': ProfileScreen(
            userPhoto: _userdata.data!.data![0].image,
            address: _userdata.data!.data![0].address,
            emailId: _userdata.data!.data![0].username,
            mobileNo: _userdata.data!.data![0].mobile,
            username: _userdata.data!.data![0].name,
            studentList: _userdata.data!.data![0].studentDetails,
          ),
          'title': 'My Profile',
          'centre': true,
          'isPopup': false
        },
        {
          'page': TicketScreen(),
          'title': 'Ticket',
          'centre': true,
          'isPopup': false
        },
        {
          'page': ResetPassword(
            email: _userdata.data!.data![0].username,
          ),
          'title': 'Reset Password',
          'centre': true,
          'isPopup': false
        },
        {
          'page': TimeTable(
            schoolId: _userdata.data!.data![0].schoolId,
            userId: _userdata.data!.data![0].studentDetails!.first.userId,
            sessionId: _userdata.data!.data![0].studentDetails!.first.sessionId,
            curriculumId: _userdata.data!.data![0].studentDetails!.first.curriculumId,
            classId: _userdata.data!.data![0].studentDetails!.first.classId,
            batchId: _userdata.data!.data![0].studentDetails!.first.batchId,
            academicYear: _userdata.data!.data![0].studentDetails!.first.academicYear,
          ),
          'title': 'Time Table',
          'centre': true,
          'isPopup': true
        }
      ];
    });
  }

  void switchingFrDash(int pageno, String id, bool isclicked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dashId', id);
    // print(pageno);
    // print('cirid in home---$id');
    setState(() {
      circularId = id;

      isClicked = isclicked;
      _pageSwitching(_activeindex);
      _seletedPageIndex = pageno;
    });
  }

  _rabbitMQAPI() async {
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();
    print('Ip data ----------------$data');
    print('Ip address ----------------${data['ip']}');
    //print('Ip data ----------------${data.runtimeType}');
    var logData = <String, Object>{
      'email': '${_userdata.data!.data![0].username}',
      'action': 'School_Diary_Home',
      'school_name': 'NIMS',
      'role_name': 'parent',
      'timestamp_server': DateTime.now().microsecondsSinceEpoch,
      'user_agent': Platform.isIOS ? "IOS" : "Android",
      'ip_address': data['ip'],
      'timestamp_date': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
    };
    print('log data map -------$logData');
    print('log data map -------${logData.runtimeType}');
    var logList = [logData];
    ConnectionSettings settings = new ConnectionSettings(
        host: "mq.bmark.in",
        authProvider: new PlainAuthenticator("admin", "rabbitMQ"));
    Client client = new Client(settings: settings);
    client.channel().then((Channel channel) =>
        channel.queue("saveLog", arguments: logData).then((value) {
          value.publish(jsonEncode(logList));
          return client.close();
        }));
  }

  //------------------------Logo hard coded(Not in use)-----------------------//
  // String _getImage(){
  //   switch(schoolId){
  //     case 'ps4vyLJhQvPZjfxaH':
  //       return  'assets/images/sharjalg.png';
  //     case '2FwuqhgeoKt6SQiCG':
  //       return  'assets/images/alainlg.png';
  //     case 'CPpbKPQTcuG97i3kv':
  //       return  'assets/images/dxblg.png';
  //     case 'm2LMtqaESFZf6xDE8':
  //       return  'assets/images/tcslg.png';
  //     default:
  //       return 'assets/images/dxblg.png';
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    //var data = userdata.data;
    // print(data.runtimeType);
    //var singleUser = UserDetails.fromJson(data as );
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        // await showDialog(
        //     context: context,
        //     builder: (_) => AlertDialog(
        //   title: Text('Are you sure you want to leave'),
        //   actions: [
        //     ElevatedButton(
        //         onPressed: () {
        //           willLeave = true;
        //           SystemNavigator.pop();
        //         },
        //         child: Text('YES')),
        //     ElevatedButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         child: Text('No')),
        //   ],
        //       actionsAlignment: MainAxisAlignment.center,
        // ));
        showGeneralDialog(
          context: context,
          pageBuilder: (ctx, a1, a2) {
            return Container();
          },
          transitionBuilder: (ctx, a1, a2, child) {
            var curve = Curves.easeInOut.transform(a1.value);
            return Transform.scale(
              scale: curve,
              child: AlertDialog(
                title: Text('Exit the Application?'),
                actions: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Color(0xff8e2de2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        willLeave = true;
                        SystemNavigator.pop();
                      },
                      child: Text('Yes')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No')),
                ],
                actionsAlignment: MainAxisAlignment.center,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
        return willLeave;
      },
      child: Scaffold(
        key: _key,
        backgroundColor: ColorUtil.mainBg,
        //endDrawer: NotifWidget(parentId: _userdata.data!.data![0].id),
        drawer: Drawer(
          child: Container(
            width: double.infinity,
            height: 1.sh,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 0.065.sh,
                      ),
                      buildHeader(
                        urlImage:
                            '${ApiConstants.baseUrl}${_userdata.data!.data![0].image}',
                        name: _userdata.data!.data![0].name.toString(),
                        email: _userdata.data!.data![0].username.toString(),
                      ),
                      SizedBox(
                        height: 0.03.sh,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 35.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFF57F17),
                                ColorUtil.greybg.shade100
                              ], // Replace with your desired gradient colors
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: const Divider(
                            thickness: 1,
                            color: Colors
                                .transparent, // Set the color to transparent
                            endIndent: 35,
                            height: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0.025.sh,
                      ),
                      _drawerItem(
                          imgLoc: 'assets/images/homeicon.png',
                          menuTitle: 'Home',
                          menuIndex: 0),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                        indent: 0.17.sw,
                        endIndent: 35,
                      ),
                      _drawerItem(
                          imgLoc: 'assets/images/ic_about.png',
                          menuTitle: 'About',
                          menuIndex: 6),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                        indent: 0.17.sw,
                        endIndent: 35,
                      ),
                      _drawerItem(
                          imgLoc: 'assets/images/ic_downloads.png',
                          menuTitle: 'Downloads',
                          menuIndex: 7),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                        indent: 0.17.sw,
                        endIndent: 35,
                      ),
                      _drawerItem(
                          imgLoc: 'assets/images/ic_profile.png',
                          menuTitle: 'My Profile',
                          menuIndex: 8),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                        indent: 0.17.sw,
                        endIndent: 35,
                      ),
                      _drawerItem(
                          imgLoc: 'assets/images/ic_report_card.png',
                          menuTitle: 'Report Cards',
                          menuIndex: 5),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                        indent: 0.17.sw,
                        endIndent: 35,
                      ),
                      _drawerItem(
                          imgLoc: 'assets/images/timetable_icon.png',
                          menuTitle: 'Time Table',
                          menuIndex: 11),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.73,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // color: Colors.yellow.shade100,
                        ),
                        child: Image(
                          // width: 230.sp,
                          image: NetworkImage(
                            'https://alpha.docme.cloud/schooldiary-logo/${_userdata.data!.data![0].schoolId}.png',
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.7,
                        color: Colors.black38,
                        indent: 0.06.sw,
                        height: 25.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Center(
                                            child: Text(
                                              'Logout',
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                color: Color(0xfffc5c65),
                                                fontSize: 16.sp,
                                                fontFamily: 'Axiforma',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          content: Container(
                                            width: double.infinity,
                                            height: 20,
                                            child: Center(
                                              child: Text(
                                                  'Are you sure want to Logout'),
                                            ),
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    var sta1 = await prefs
                                                        .remove('loginResp');
                                                    var sta2 = await prefs
                                                        .remove('isLogged');
                                                    //print('---$sta1----$sta2');
                                                    if (sta1 == true &&
                                                        sta2 == true) {
                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                              context,
                                                              LoginScreen
                                                                  .routeName,
                                                              (route) => false);
                                                    }
                                                    setState(() {
                                                      //isLoading = true;
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    primary: Color(0xff8e2de2),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  child: Text('Yes'),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      primary: Colors.grey,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('No'))
                                              ],
                                            )
                                          ],
                                        ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_circle_left_outlined,
                                    color: Color(0xfffc5c65),
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Log Out',
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Axiforma",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 11,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  _seletedPageIndex = 10;
                                });
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'assets/images/Unlock@2x.png.png'),
                                    width: 16,
                                    height: 16,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Reset Password',
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Axiforma",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 11,
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: _customBottomNavBar(),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              _pages[_seletedPageIndex]['centre'] as bool
                  ? Container(
                      child: customAppBar(
                          isPop: _pages[_seletedPageIndex]['isPopup'] as bool,
                          img: 'assets/images/menu.png',
                          name: _userdata.data!.data![0].parentName,
                          title: _pages[_seletedPageIndex]['title'].toString(),
                          isCentre:
                              _pages[_seletedPageIndex]['centre'] as bool),
                    )
                  : Stack(
                      children: [
                        Container(
                          width: 1.sw,
                          height: 280,
                        ),
                        customAppBar(
                            isPop: _pages[_seletedPageIndex]['isPopup'] as bool,
                            img: 'assets/images/menu.png',
                            name: _userdata.data!.data![0].parentName,
                            title:
                                _pages[_seletedPageIndex]['title'].toString(),
                            isCentre:
                                _pages[_seletedPageIndex]['centre'] as bool),
                        Positioned(
                          top: 100,
                          child: Container(
                            width: 1.sw,
                            height: 180,
                            child: CarouselSlider.builder(
                              itemCount: _students.length,
                              itemBuilder: (context, index, realIndex) {
                                // final name = _students[index].name;
                                // final classofstd = _students[index].studentDetailClass;
                                // final batchofstd = _students[index].batch;
                                // final imgUrl =
                                //     'https://teamsqa3000.educore.guru${_students[index].photo}';
                                final name = _students[_activeindex].name;
                                print('name of student-------------$name');
                                final classofstd =
                                    _students[_activeindex].studentDetailClass;
                                final batchofstd =
                                    _students[_activeindex].batch;
                                final imgUrl =
                                    'https://teamsqa3000.educore.guru${_students[_activeindex].photo}';
                                return nameCard(
                                    studentName: name.toString(),
                                    photourl: photoUrl,
                                    grade: batchofstd.toString(),
                                    classofstd: classofstd.toString());
                              },
                              options: CarouselOptions(
                                  initialPage: _activeindex,
                                  height: 170,
                                  //enlargeCenterPage: true,
                                  viewportFraction: 1,
                                  enableInfiniteScroll: false,
                                  onPageChanged: (index, reason) {
                                    print('index------$index');
                                    // print('rea------$reason');
                                    setState(() {
                                      _activeindex = index;
                                      _pageSwitching(_activeindex);
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
              _pages[_seletedPageIndex]['page'] as Widget
            ],
          ),
        ),
      ),
    );
  }

  Widget nameCard(
          {required String studentName,
          required String photourl,
          required String grade,
          required String classofstd}) =>
      Container(
        width: 1.sw - 40,
        //height: 210,
        padding: EdgeInsets.symmetric(vertical: 15),
        //margin: EdgeInsets.symmetric(horizontal: 20),
        //margin: EdgeInsets.only(bottom: -2),
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
                offset: Offset(0, 0),
                blurRadius: 5,
                spreadRadius: 0),
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xff8829e1),
              child: CircleAvatar(
                radius: 27,
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  child: CachedNetworkImage(
                    imageUrl: photourl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      'assets/images/userImage.png',
                      width: 50,
                      height: 50,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/userImage.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            AutoSizeText(
              studentName,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff8829e1),
                  fontFamily: 'Axiforma',
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Grade',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: Color(0xffcd758e),
                      fontFamily: 'Axiforma',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  classofstd,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: Color(0xffcd758e),
                      fontFamily: 'Axiforma',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  grade,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: Color(0xffcd758e),
                      fontFamily: 'Axiforma',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            buildIndicator()
          ],
        ),
      );

  Widget _drawerItem(
          {required String imgLoc,
          required String menuTitle,
          required int menuIndex}) =>
      InkWell(
        onTap: () {
          setState(() {
            Navigator.of(context).pop();
            _seletedPageIndex = menuIndex;
            print(_seletedPageIndex);
          });
        },
        child: Container(
          // width: double.infinity,
          // height: 40,
          padding: const EdgeInsets.fromLTRB(30, 18, 0, 18),
          child: Row(
            children: [
              Image(
                image: AssetImage(imgLoc),
                width: menuIndex == 11 ? 20 : 25,
                height: menuIndex == 11 ? 20 : 25,
              ),
              SizedBox(
                width: 30.w,
              ),
              Text(
                menuTitle,
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Axiforma",
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: _activeindex,
        count: _students.length,
        effect: SlideEffect(dotWidth: 9, dotHeight: 9),
      );

  Widget customAppBar(
          {String? img,
          String? title,
          bool isCentre = false,
          String? name,
          bool isPop = false}) =>
      Container(
        width: 1.sw,
        height: isCentre ? 80 : 120,
        decoration: title == 'About'
            ? const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/MaskGroup3.png',
                  ),
                  fit: BoxFit.cover,
                ),
              )
            : const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/MaskGroup3.png'),
                  fit: BoxFit.cover,
                ),
              ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (title == 'Assessments')
                  ? InkWell(
                      onTap: () {
                        // _key.currentState!.openDrawer();
                        setState(() {
                          _seletedPageIndex = 0;
                        });
                      },
                      child: Container(
                        //color: Colors.blue,
                        padding:
                            const EdgeInsets.only(top: 8, left: 8, right: 6),
                        child: Image(
                          image: AssetImage('assets/images/homei.png'),
                          width: 40,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: InkWell(
                        onTap: () {
                          _key.currentState!.openDrawer();
                        },
                        child: Image(
                          image: AssetImage(img!),
                          width: 40,
                        ),
                      ),
                    ),
              isCentre
                  ? Container(
                      // color: Colors.green,
                      width: 1.sw - 140,
                      child: Center(
                        child: Text(
                          title!,
                          textScaleFactor: 1.0,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: ColorUtil.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  // : Padding(
                  //     padding: const EdgeInsets.all(10.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           'Hello,',
                  //           style: TextStyle(
                  //               color: const Color(0xffe8a420),
                  //               fontWeight: FontWeight.w300,
                  //               fontSize: 14.sp),
                  //         ),
                  //         SizedBox(
                  //           width: 200,
                  //           child: Text(
                  //             name!,
                  //             maxLines: 1,
                  //             overflow: TextOverflow.ellipsis,
                  //             style: TextStyle(
                  //                 color: const Color(0xfffed330),
                  //                 fontWeight: FontWeight.w400,
                  //                 fontSize: 14.sp),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  : Container(
                      width: 1.sw - 60,
                      //color: Colors.lime ,
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hello,',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: const Color(0xffe8a420),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                width: 200,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    name!,
                                    textScaleFactor: 1.0,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: const Color(0xfffed330),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp),
                                  ),
                                ),
                              )
                            ],
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => NotifWidget(
                                            parentId:
                                                _userdata.data!.data![0].id)));
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    //color: Colors.teal,
                                  ),
                                  Icon(
                                    Icons.notification_important_rounded,
                                    size: 32,
                                    color: Color(0xfffed330),
                                  ),
                                  // Positioned(
                                  //     top: 11,
                                  //     right: 15,
                                  //     child: Container(
                                  //       width: 8,
                                  //       height: 8,
                                  //       decoration: BoxDecoration(
                                  //           color: Colors.red,
                                  //           borderRadius:
                                  //               BorderRadius.circular(
                                  //                   8)),
                                  //       // child: Center(
                                  //       //     child: Text(
                                  //       //   '$notifNo',
                                  //       //   style: TextStyle(
                                  //       //       color: Colors.purple,
                                  //       //       fontSize: 5),
                                  //       // )),
                                  //     ))
                                ],
                              ))
                        ],
                      ),
                    ),
              (isPop)
                  ? InkWell(
                      onTap: () {
                        _selectChildPopUp(context: context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: CachedNetworkImage(
                              imageUrl: photoUrl,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                              // placeholder: (context, url) => SizedBox(
                              //   width: 20,
                              //   height: 20,
                              //   child: CircularProgressIndicator(),
                              // ),
                              placeholder: (context, url) => Image.asset(
                                'assets/images/userImage.png',
                                width: 30,
                                height: 30,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/userImage.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : isCentre
                      ? Container(width: 50)
                      : Container(),
            ],
          ),
        ),
      );
  Widget _customBottomNavBar() => Container(
        width: double.infinity,
        height: 90,
        padding: EdgeInsets.fromLTRB(0, 2, 8, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                offset: Offset(1, 1),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            navBarItem(
                navIcon: Icons.campaign_outlined,
                navLabel: 'Circular',
                indexPassed: 1,
                selectedBg: Color(0xffffc8d1),
                selectedBgScnd: Color(0xfffff6f7),
                icnColor: Color(0xfffd3a84)),
            navBarItem(
                navIcon: Icons.menu_book_outlined,
                navLabel: 'Assignment',
                indexPassed: 2,
                selectedBg: Color(0xffaddcff),
                selectedBgScnd: Color(0xffeaf6ff),
                icnColor: Color(0xff5558ff)),
            navBarItem(
                navIcon: Icons.calendar_month_outlined,
                navLabel: 'Calendar',
                indexPassed: 3,
                selectedBg: Color(0xffffbef9),
                selectedBgScnd: Color(0xfffff1ff),
                icnColor: Color(0xffa93aff)),
            navBarItem(
                navIcon: Icons.payments_outlined,
                navLabel: 'Fees',
                indexPassed: 4,
                selectedBg: Color(0xffc3ffe8),
                selectedBgScnd: Color(0xfff0fff4),
                icnColor: Color(0xff00b59c)),
            navBarItem(
                navIcon: Icons.pie_chart,
                navLabel: 'Assessments',
                indexPassed: 5,
                selectedBg: Color(0xffffc8d1),
                selectedBgScnd: Color(0xfffff6f7),
                icnColor: Color(0xfffd3a84))
          ],
        ),
      );
  Widget navBarItem(
          {required IconData navIcon,
          required String navLabel,
          required int indexPassed,
          required Color selectedBg,
          required Color selectedBgScnd,
          required Color icnColor}) =>
      InkWell(
        onTap: () {
          setState(() {
            _seletedPageIndex = indexPassed;
          });
        },
        child: Container(
          width: 70,
          height: 70,

          // decoration: BoxDecoration(
          //   color: Colors.grey,
          //   borderRadius: BorderRadius.circular(30)
          //
          // ),
          child: Column(
            children: [
              Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      //color: Colors.grey,
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: _seletedPageIndex == indexPassed
                              ? [selectedBg, selectedBgScnd]
                              : [Color(0xfff2f2f2), Color(0xfff2f2f2)]),
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    navIcon,
                    color: _seletedPageIndex == indexPassed
                        ? icnColor
                        : Color(0xff818181),
                  )),
              Text(
                navLabel,
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'Axiforma',
                  fontWeight: FontWeight.w400,
                  color: _seletedPageIndex == indexPassed
                      ? icnColor
                      : Color(0xff787878),
                ),
              )
            ],
          ),
        ),
      );
  _selectChildPopUp({
    required BuildContext context,
  }) =>
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                  child: Text(
                    'Select Child',
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Axiforma',
                    ),
                  ),
                ),
                setupAlertDialoadContainer(),
              ],
            ),
          ),
        ),
      );

  Widget setupAlertDialoadContainer() {
    return Container(
      height: (_students.length > 3)
          ? 240
          : _students.length * 60 + 80, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _students.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
                color: _selectedChild == _students[index].userId
                    ? ColorUtil.lightPurple.withOpacity(0.2)
                    : ColorUtil.white,
            borderRadius: BorderRadius.circular(20)
            ),
            child: ListTile(
              onTap: () {
                Navigator.of(context).pop();
                _pageSwitching(index);
              },
              // tileColor: _selectedChild == _students[index].userId
              //     ? ColorUtil.lightPurple.withOpacity(0.2)
              //     : ColorUtil.white,
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: ColorUtil.lightPurple,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  child: CachedNetworkImage(
                    //imageUrl:  _students[index].photo?? ' ',
                    imageUrl:
                        '${ApiConstants.downloadUrl}${_students[index].photo}',
                    width: 45,
                    height: 45, fit: BoxFit.cover,
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
              title: Text(
                _students[index].name!,
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: const Color(0xff34378b),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Axiforma",
                  fontSize: 13.sp,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                      width: 130,
                      height: 18,
                      margin: EdgeInsets.only(bottom: 4),
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                          color: Color(0xffececf9),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        'ADMN NO:${_students[index].admissionNumber}',
                        textScaleFactor: 1.0,
                        style: admissionAndgrdStyle(),
                      )),
                  //SizedBox(height: 5,),
                  Container(
                    width: 130,
                    height: 18,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                        color: Color(0xffececf9),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      'Grade ${_students[index].studentDetailClass}${_students[index].batch}',
                      textScaleFactor: 1.0,
                      style: admissionAndgrdStyle(),
                    ),
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xff8829e1),
            child: CircleAvatar(
              radius: 27,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(60)),
                child: CachedNetworkImage(
                  imageUrl: urlImage,
                  width: 50,
                  height: 50,
                  // placeholder: (context, url) => SizedBox(
                  //   width: 20,
                  //   height: 20,
                  //   child: CircularProgressIndicator(),
                  // ),
                  placeholder: (context, url) => Image.asset(
                    'assets/images/userImage.png',
                    width: 50,
                    height: 50,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/userImage.png',
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 180.w,
                child: AutoSizeText(
                  name,
                  maxFontSize: 15,
                  textScaleFactor: 1.0,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color(0xff517bfa),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Axiforma',
                      fontSize: 15),
                ),
              ),
              SizedBox(
                width: 180.w,
                child: AutoSizeText(
                  //'asgdkgjhgjhgaasfjkghdsghashgfhsggdfhgfhgjas',
                  email,
                  textScaleFactor: 1.0,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xffe8a420),
                    fontSize: 12,
                    fontFamily: 'Axiforma',
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  admissionAndgrdStyle() => TextStyle(
      color: Color(0xff34378b).withOpacity(0.5),
      fontWeight: FontWeight.w400,
      fontSize: 10.sp);
}
