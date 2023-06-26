import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../Models/user_model.dart';
import '../Util/api_constants.dart';
import '../Models/login_model.dart';

class UserProvider with ChangeNotifier {
  // var users = Users();

  // Users get userdetails{
  //   return users;
  // }

  Future<dynamic> getUserDetails(Login user) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.login}';
    try {
      print(url);
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, String> apiBody = {
        'username': user.username,
        'password': user.password
      };

      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      // print(json.decode(respString));
      //  if(json.decode(respString)['status']['code']==200){
      //    users = Users(
      //      status: json.decode(respString)['status'],
      //      data: json.decode(respString)['data']
      //    );
      //    notifyListeners();
      //  }
      return json.decode(respString);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> mobileLogin(String mobNo, bool isSentOtp) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.mobileVerification}';
    try {
      print(url);
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, String> apiBody = {
        "phone": mobNo,
        "otp": isSentOtp.toString()
      };

      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      // print(json.decode(respString));
      //  if(json.decode(respString)['status']['code']==200){
      //    users = Users(
      //      status: json.decode(respString)['status'],
      //      data: json.decode(respString)['data']
      //    );
      //    notifyListeners();
      //  }
      return json.decode(respString);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // Future<dynamic> verfiOTP(String mobNo,String devId,String otp) async {
  //   var url = '${ApiConstants.baseUrl}${ApiConstants.otpValidation}';
  //   try {
  //     print(url);
  //     Map<String, String> apiHeader = {
  //       'x-auth-token': '<YOUR TOKEN>',
  //       'Content-Type': 'application/json',
  //       'API-Key': '<YOUR API KEY>'
  //     };
  //     Map<String, String> apiBody = {
  //       "phone": mobNo,
  //       "otp": otp,
  //       "device_id": devId
  //     };
  //
  //     var request = http.Request('POST', Uri.parse(url));
  //     request.body = (json.encode(apiBody));
  //     print('Login api body---------------------->${request.body}');
  //     request.headers.addAll(apiHeader);
  //     http.StreamedResponse response = await request.send();
  //     var respString = await response.stream.bytesToString();
  //     // print(json.decode(respString));
  //     //  if(json.decode(respString)['status']['code']==200){
  //     //    users = Users(
  //     //      status: json.decode(respString)['status'],
  //     //      data: json.decode(respString)['data']
  //     //    );
  //     //    notifyListeners();
  //     //  }
  //     return json.decode(respString);
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  Future<dynamic> getDashboardfeed(String parentId, String studId) async {
    var url =
        '${ApiConstants.baseUrl}${ApiConstants.dashboardFeed}/$parentId/$studId';
    print('----url---------$url');
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getCircular(
      String parentId, String childId, String acadYear) async {
    var url =
        '${ApiConstants.baseUrl}${ApiConstants.circular}/$parentId/$childId/$acadYear/Circular';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getAssignment(
      String parentId, String childId, String acadYear) async {
    var url =
        '${ApiConstants.baseUrl}${ApiConstants.circular}/$parentId/$childId/$acadYear/Assignment';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getCalendarEvents(
      String schoolId, String childId, String acadYear) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.calendarEvents}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, String> apiBody = {
        "school_id": schoolId,
        "child_id": childId,
        "academic_year": acadYear
      };
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getPublishedReport(
      String schoolId, String childId, String acadYear) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.reportPublished}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, Map<String, String>> apiBody = {
        "args": {
          "user_id": childId,
          "schoolId": schoolId,
          "passedSelectedYear": acadYear
        }
      };
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getExams(String schoolId, String acadYear, String currId,
      String batchId, String stdId, String sessionId, String clsId) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.exams}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, String> apiBody = {
        "school_id": schoolId,
        "academic_year": acadYear,
        "curriculum_id": currId,
        "batch_id": batchId,
        "student_id": stdId,
        "session_id": sessionId,
        "class_id": clsId
         // "orgin": "educare"
      };
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getHallticket(String stdId) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.hallTicket}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, String> apiBody = {"child_id": stdId};
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getFeeDetail(String admnNo, String dataToken) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.feeDetails}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, String> apiBody = {
        // "school_data_url": "https://sqa.docme.online/bm-school/api/app",
        "school_data_url": ApiConstants.schoolDataUrl,
        //"school_data_url": "https://bmark.nimsuae.com/api/App", //--Live
        "admn_no": admnNo,
        //"school_data_token": "7a9d733269d23bc35b04b56dc855d330",
        "school_data_token": dataToken,
        "version": "2.0.0"
      };
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getDetailedReport(
      String consoleId, String schlId, String stdId, bool mndet) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.detailedReport}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, Map<String, dynamic>> apiBody = {
        "args": {
          // "FILE_UPLOAD_URL": "https://teamsqa4000.educore.guru",
          "FILE_UPLOAD_URL": ApiConstants.downloadUrl,
          // "SITE_URL": "https://teamsqa3000.educore.guru",
          "SITE_URL": ApiConstants.baseUrl,
          "asset_format": false,
          // "clientFileServer": "https://teamsqa4000.educore.guru",
          "clientFileServer": ApiConstants.downloadUrl,
          "forCT": false,
          "is_consolidated": false,
          "kb_consolidatedFlag": false,
          "pdfFalg": false,
          "rc_id": consoleId,
          "school_id": schlId,
          "studentId": stdId,
          "template_view": "cbse",
          "yearFromClient": "2022-2023",
          "minimum_details": mndet
        }
      };
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getAFLReport(String stdId, String qpId, String schlId) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.aflReport}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, String> apiBody = {
        "student_id": stdId,
        "qp_id": qpId,
        "page": "1",
        "school_id": schlId
      };
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getNotification(String parentId) async {
    var url =
        '${ApiConstants.baseUrl}${ApiConstants.notification}/$parentId/1/educare';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> googleLogin(String email) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.googleLogin}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, String> apiBody = {"username": email};
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> resetPassword(
      String usename, String currentPass, String newPass) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.changePassword}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, String> apiBody = {
        "username": usename,
        "current_password": currentPass,
        "new_password": newPass
      };
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }


  Future<dynamic> forgetPassword(String email) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.forgetPassword}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, String> apiBody = {"username": email};
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getReceipt(
      String parentEmail, String admnNo, String voucher, String token) async {
    var url = '${ApiConstants.getReceiptByEmail}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
        'API-Key': '<YOUR API KEY>'
      };
      Map<String, String> apiBody = {
        "action": "sentVoucherEmail",
       // "parent_email": 'faizal@docme.cloud',
        "parent_email": parentEmail,
        "admn_no": admnNo,
        //"token": token,
        "token": "7a9d733269d23bc35b04b56dc855d330",
        "voucher_code": voucher
      };
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> tokenUpdate(String email, String token) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.loginTracker}';
    print(url);
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
      };
      Map<String, String> apiBody = {
        "username": email,
        "device_id": token
      };
      print(apiBody);
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getVersionUpdates({required String version, required String appType}) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.versionCheck}';
    print('--$url');
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
      };
      Map<String, String> apiBody = {
        "current_version": version,
        "app_type": appType
      };
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getTimetable({
    required String schoolId,
    required String userId,
    required String sessionId,
    required String curriculumId,
    required String classId,
    required String batchId,
    required String academicYear}) async {
    var url = '${ApiConstants.baseUrl}${ApiConstants.timeTable}';
    print('--$url');
    try {
      Map<String, String> apiHeader = {
        'x-auth-token': '<YOUR TOKEN>',
        'Content-Type': 'application/json',
      };
      Map<String, String> apiBody = {
        "school_id": schoolId,
        "user_id": userId,
        "session_id": sessionId,
        "curriculum_id": curriculumId,
        "class_id": classId,
        "batch_id": batchId,
        "academic_year": academicYear
      };
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      print('Login api body---------------------->${request.body}');
      request.headers.addAll(apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      //print(json.decode(respString));
      return json.decode(respString);
    } catch (e) {
      print(e);
    }
  }
}
