import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/user_model.dart';
import '../Provider/user_provider.dart';
import '../Screens/login_screen.dart';
import '../Util/api_constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _user = Users();

  @override
  void initState() {
    getDatafromPrefs();
    // TODO: implement initState
    //Timer(Duration(seconds: 3), ()=>Navigator.of(context).pushNamed(LoginScreen.routeName));
    super.initState();
  }

  void _showVersionDialog(String url) {
    Alert(
      onWillPopActive: true,
      style: AlertStyle(isCloseButton: false),
      context: context,
      type: AlertType.warning,
      // closeFunction: () {
      //   Navigator.pop(context);
      // },
      title: "Update Now",
      desc: "Latest version of School Diary Available. Please update to "
          "Continue.",
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
            bool time = false;
            navigation(time);
          },
          color: const Color.fromRGBO(0, 179, 134, 1.0),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          onPressed: () async {
            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          },
          color: const Color.fromRGBO(179, 0, 134, 1.0),
          child: const Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  Future<dynamic> checkVersion() async {
    try {
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .getVersionUpdates(version: ApiConstants.version, appType: ApiConstants.appType);
      print('staus code-------------->$resp');
      if (resp['data']['updateApp'] && resp['data']['url'] != null) {
        _showVersionDialog(resp['data']['url']);
      }
      return resp['data']['updateApp'];
    } catch(e) {
      print(e);
      return false;
    }
  }

  navigation(bool time) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('isLogged') == true){
      _user = Users.fromJson(json.decode(prefs.getString('loginResp')!));
      Timer(Duration(seconds: time ? 1 : 0), ()=>Navigator.of(context).pushNamed(HomeScreen.routeName,arguments: _user));
    }else{
      Timer(Duration(seconds: time ? 1 : 0), ()=>Navigator.of(context).pushReplacementNamed(LoginScreen.routeName));
    }
  }

  getDatafromPrefs() async {
    bool update = await checkVersion();
    if(!update) {
      bool time = true;
      navigation(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 1.sw,
          child: Image.asset('assets/images/splash_bg.png',fit: BoxFit.cover,),
        ),
        Center(
          child: Image(image: AssetImage('assets/images/splash_logo.png'),
            width: 0.5.sw,
          ),
        ),
      ],
    );
  }
}
