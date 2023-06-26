import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../Provider/user_provider.dart';
import '../Util/color_util.dart';
import '../Util/spinkit.dart';

class ResetPassword extends StatefulWidget {
  final String? email;
  const ResetPassword({Key? key, this.email}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController _currentPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  var _isloading = false;
  void _showToast(BuildContext context, String errText,Color color) {
   // final scaffold = Scaffold.of(context);
    // scaffold.showSnackBar(
    //   SnackBar(
    //     content: Text(errText),
    //     backgroundColor: color,
    //     margin: EdgeInsets.all(8),
    //     behavior: SnackBarBehavior.floating,
    //   ),
    // );
    ScaffoldMessenger.of(context).showSnackBar(     SnackBar(
      content: Text(errText),
      backgroundColor: color,
      margin: EdgeInsets.all(8),
      behavior: SnackBarBehavior.floating,
    ),);
  }

  _restPassw(String usename, String currentPass, String newPass) async {
    try {
      setState(() {
        _isloading = true;

      });
      var resp = await Provider.of<UserProvider>(context, listen: false)
          .resetPassword(usename, currentPass, newPass);
      print(resp.runtimeType);
      print('staus code-------------->${resp['status']['code']}');
      if (resp['status']['code'] == 200) {

        print(resp['data']['message']);
        _showToast(context, resp['data']['message'],ColorUtil.green);
        setState(() {
          _isloading = false;
          _currentPassword.clear();
          _newPassword.clear();
          _confirmPassword.clear();
        });
        // _assignList = Assignment.fromJson(resp);
        // _assignments = _assignList.data!.details!;
        // _circularList = Circular.fromJson(resp);
        //print(_circularList.data!.details!.first.title);
        // setState(() {
        //   // _ciculars = _circularList.data!.details!;
        // });
      } else if (resp['status']['code'] == 400) {
        setState(() {
          _isloading = false;
        });
        _showToast(context, resp['error']['message'],Colors.red);
      } else {
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      _isloading?  Center(
            child: Container(
          width: 200,
          height: 400,
          //color: Colors.red,
          child: spinkit,
        )):SizedBox(),
        Container(
          height: 1.sh - (400+MediaQuery.of(context).viewInsets.bottom),
          width: 1.sw,
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.only(left: 36, top: 10, right: 50),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: 0.04.sh,
                  // ),
                  // Text(
                  //   'Reset',
                  //   style: TextStyle(
                  //       color: Color(0xff313131),
                  //       fontWeight: FontWeight.w400,
                  //       fontFamily: "Montserrat",
                  //       fontStyle: FontStyle.normal,
                  //       fontSize: 15.sp),
                  // ),
                  // SizedBox(
                  //   height: 0.01.sh,
                  // ),
                  // Text(
                  //   'Password',
                  //   style: TextStyle(
                  //       color: Color(0xff313131),
                  //       fontWeight: FontWeight.w400,
                  //       fontFamily: "Montserrat",
                  //       fontStyle: FontStyle.normal,
                  //       fontSize: 10.sp),
                  // ),
                  // SizedBox(
                  //   height: 0.01.sh,
                  // ),
                  TextFormField(
                    controller: _currentPassword,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Current Password',
                        labelStyle: TextStyle(
                            color: Color(0xff34378b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0)),
                  ),
                  // SizedBox(
                  //   height: 0.01.sh,
                  // ),
                  TextFormField(
                    controller: _newPassword,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'New Password',
                        labelStyle: TextStyle(
                            color: Color(0xff34378b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0)),
                  ),
                  // SizedBox(
                  //   height: 0.01.sh,
                  // ),
                  TextFormField(
                    controller: _confirmPassword,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff34378b))),
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                            color: Color(0xff34378b),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0)),
                  ),
                  SizedBox(
                    height: 0.04.sh,
                  ),
                  InkWell(
                    onTap: () {
                      if (_currentPassword.value == null ||
                          _currentPassword.value.text.isEmpty) {
                        print('current password nil');
                        _showToast(context, 'Please Enter the Current Password',Colors.red);
                      } else if (_newPassword.value == null ||
                          _newPassword.value.text.isEmpty) {
                        _showToast(context, 'Please Enter the New Password',Colors.red);
                      } else if (_newPassword.value.text ==
                          _currentPassword.value.text) {
                        _showToast(context,
                            'New Password and Confirm Password does not Match',Colors.red);
                      } else if (_confirmPassword.value == null ||
                          _confirmPassword.value.text.isEmpty) {
                        _showToast(context, 'Please Enter the Confirm Password',Colors.red);
                      } else if (!(_newPassword.value.text ==
                          _confirmPassword.value.text)) {
                        _showToast(context,
                            'New Password and Confirm Password does not Match',Colors.red);
                      } else {
                        print('validation success');
                        _restPassw(widget.email!, _currentPassword.value.text,
                            _newPassword.value.text);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 0.55.sw,
                      decoration: BoxDecoration(
                          color: Color(0xff25dbdb),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: EdgeInsets.only(top: 11),
                        child: Text(
                          'UPDATE PASSWORD',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              fontSize: 13.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
