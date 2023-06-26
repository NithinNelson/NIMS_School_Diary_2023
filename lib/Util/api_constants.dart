
//----------------------------URLs----------------------------------//

class ApiConstants {

  //----------------------------Live URLs----------------------------------//

  //----------------------------Test URLs----------------------------------//
  static const baseUrl = 'https://teamsqa3000.educore.guru';
  static const downloadUrl = 'https://teamsqa4000.educore.guru';
  static const getReceiptByEmail = "https://sqa.docme.online/bm-school/api/App"; //--
  static const schoolDataUrl = "https://sqa.docme.online/bm-school/api/app";


  //----------------------------Constants----------------------------------//

  static const login = '/v1/schooldiary_login';
  static const dashboardFeed ='/v1/dashboard_feed_student';
  static const circular ='/v0/announcement/received_student';
  static const calendarEvents = '/v0/educare/attendance_events';
  static const reportPublished = '/v0/reportcards/published/list';
  static const exams = '/v0/educare/activity_reports';
  static const hallTicket = '/v1/get_hall_ticket';
  static const feeDetails = '/v0/parent/portal/fee';
  static const detailedReport = '/v0/reportcards/published/getReportCardPublished';
  static const aflReport = '/v0/assesment-report/activity/student/report';
  static const notification = '/v0/notifications/page/details';
  static const googleLogin = "/v0/educare_login_google";
  static const changePassword = "/v0/educare/change_password";
  static const forgetPassword = "/v1/forgot_password";
  static const loginTracker = "/v0/educare/add/login_tracker";
  static const mobileVerification = "/v1/schooldiary_mobileverification";
  // static const mobileVerification = "/v0/educare_mobileverification";
  // static const otpValidation = "/v1/schooldiary_mobileverification";
  static const versionCheck = "/v0/educare/version/check";
  static const timeTable = "/v0/educare/timetable";


  //----------------------------For Version Check----------------------------------//
  static const appType = "school_diary";
  static const version = "2.0.0";
}