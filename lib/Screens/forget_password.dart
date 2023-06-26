import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Provider/user_provider.dart';
import '../Util/color_util.dart';
import '../Util/spinkit.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = '/forget-password';
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _rPass = TextEditingController();
  var _isLoading = false;

  forgetPassword(String email) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .forgetPassword(email);
      print(resp.runtimeType);
      //print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {
        setState(() {
          _isLoading = false;
        });
        print(resp['data']['message']);
        _showToast(context, resp['data']['message'], ColorUtil.green);
        // _user =  Users.fromJson(resp);
        // _user = Users(
        //   status: resp['status'] as Map<String,dynamic>,
        //   data: resp['data']
        // );
        //   print(_user.status!.code);
        //print('ok');
        //Navigator.of(context).pushNamed(HomeScreen.routeName,arguments: _user);
      } else {
        setState(() {
          _isLoading = false;
        });
        _showToast(context, 'Invalid Credentials', ColorUtil.circularRed);
      }
    } catch (e) {
      print(e);
    }
  }

  void _showToast(BuildContext context, String errText, Color color) {
    // scaffoldKey.currentState!.showSnackBar(
    //   SnackBar(
    //     content: Text(errText),
    //     backgroundColor: ColorUtil.green,
    //     margin: EdgeInsets.all(8),
    //     behavior: SnackBarBehavior.floating,
    //   ),
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errText),
        backgroundColor: color,
        margin: EdgeInsets.all(8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorUtil.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text('Forgot Password'),
      ),
      body: Stack(
        children: [
          Container(
            width: 1.sw,
            height: 1.sh,

            // color: Colors.yellow,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Center(child: Image.asset('assets/images/icon.png')),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 1.sw,
                    height: 72,
                    //padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    // color: Colors.red,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0x1f0b5a7d),
                              offset: Offset(0, 3),
                              blurRadius: 20,
                              spreadRadius: 0)
                        ],
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _rPass,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: ColorUtil.paidBor,
                        minimumSize: Size(1.sw - 40, 60)),
                    onPressed: () {
                      print('ff');
                      print(_rPass.value.text.toString());
                      if (_rPass.value.text.isEmpty) {
                        _showToast(
                            context, 'Please Enter a Valid Email', Colors.red);
                      } else {
                        forgetPassword(_rPass.value.text.toString());
                      }
                    },
                    child: Text('Submit'),
                  )
                ],
              ),
            ),
          ),
          _isLoading
              ? Center(
                  child: Container(
                  width: 1.sw,
                  height: 1.sh,
                  color: _isLoading ? Colors.black38 : Colors.transparent,
                  child: spinkit,
                ))
              : SizedBox()
        ],
      ),
    );
  }
}
