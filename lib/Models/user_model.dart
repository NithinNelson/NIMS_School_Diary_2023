// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));



class Users {
  Users({
    this.status,
    this.data,
  });

  Status? status;
  User? data;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    status: Status.fromJson(json["status"]),
    data: User.fromJson(json["data"]),
  );


}

class User {
  User({
    this.message,
    this.data,
  });

  String? message;
  List<UserDetails>? data;

  factory User.fromJson(Map<String, dynamic> json) => User(
    message: json["message"],
    data: List<UserDetails>.from(json["data"].map((x) => UserDetails.fromJson(x))),
  );

}

class UserDetails {
  UserDetails({
    this.id,
    this.username,
    this.name,
    this.parentName,
    this.schoolId,
    this.roleIds,
    this.mobile,
    this.address,
    this.image,
    this.academicYear,
    this.schoolLogo,
    this.token,
    this.studentDetails,
    this.schoolDataToken
  });

  String? id;
  String? username;
  String? name;
  String? parentName;
  String? schoolId;
  List<String>? roleIds;
  String? mobile;
  String? address;
  String? image;
  String? academicYear;
  String? schoolLogo;
  String? token;
  List<StudentDetail>? studentDetails;
  String? schoolDataToken;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    id: json["_id"],
    username: json["username"],
    name: json["name"],
    parentName: json["parent_name"],
    schoolId: json["school_id"],
    roleIds: List<String>.from(json["role_ids"].map((x) => x)),
    mobile: json["mobile"],
    address: json["address"],
    image: json["image"],
    academicYear: json["academic_year"],
    schoolLogo: json["school_logo"],
    token: json["_token"],
    studentDetails: List<StudentDetail>.from(json["student_details"].map((x) => StudentDetail.fromJson(x))),
    schoolDataToken: json["school_data_token"],
  );

}

class StudentDetail {
  StudentDetail({
    this.id,
    this.sessionId,
    this.curriculumId,
    this.classId,
    this.batchId,
    this.academicYear,
    this.schoolId,
    this.userId,
    this.allAcademicYear,
    this.session,
    this.curriculum,
    this.studentDetailClass,
    this.batch,
    this.name,
    this.admissionNumber,
    this.username,
    this.gender,
    this.photo,
  });

  String? id;
  String? sessionId;
  String? curriculumId;
  String? classId;
  String? batchId;
  String? academicYear;
  String? schoolId;
  String? userId;
  List<AllAcademicYear>? allAcademicYear;
  String? session;
  String? curriculum;
  String? studentDetailClass;
  String? batch;
  String? name;
  String? admissionNumber;
  String? username;
  String? gender;
  String? photo;

  factory StudentDetail.fromJson(Map<String, dynamic> json) => StudentDetail(
    id: json["_id"],
    sessionId: json["session_id"],
    curriculumId: json["curriculum_id"],
    classId: json["class_id"],
    batchId: json["batch_id"],
    academicYear: json["academic_year"],
    schoolId: json["school_id"],
    userId: json["user_id"],
    allAcademicYear: List<AllAcademicYear>.from(json["allAcademic_year"].map((x) => AllAcademicYear.fromJson(x))),
    session: json["session"],
    curriculum: json["curriculum"],
    studentDetailClass: json["class"],
    batch: json["batch"],
    name: json["name"],
    admissionNumber: json["admission_number"],
    username: json["username"],
    gender: json["gender"],
    photo: json["photo"],
  );


}

class AllAcademicYear {
  AllAcademicYear({
    this.id,
    this.year,
    this.status,
    this.startDate,
  });

  String? id;
  String? year;
  String? status;
  DateTime? startDate;

  factory AllAcademicYear.fromJson(Map<String, dynamic> json) => AllAcademicYear(
    id: json["_id"],
    year: json["year"],
    status: json["status"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
  );


}

class Status {
  Status({
    this.code,
    this.message,
  });

  int? code;
  String? message;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    code: json["code"],
    message: json["message"],
  );

}
