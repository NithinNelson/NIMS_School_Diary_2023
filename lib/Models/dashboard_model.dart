// To parse this JSON data, do
//
//     final dashboard = dashboardFromJson(jsonString);

import 'dart:convert';

Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));


class Dashboard {
  Dashboard({
    this.status,
    this.data,
  });

  Status? status;
  Data? data;

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
    status: Status.fromJson(json["status"]),
    data: Data.fromJson(json["data"]),
  );

}

class Data {
  Data({
    this.message,
    this.source,
    this.dataCount,
    this.data,
  });

  String? message;
  String? source;
  int? dataCount;
  List<DashboardItem>? data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
    source: json["source"],
    dataCount: json["data_count"],
    data: List<DashboardItem>.from(json["data"].map((x) => DashboardItem.fromJson(x))),
  );

}

class DashboardItem {
  DashboardItem({
    this.type,
    this.title,
    this.academic,
    this.status,
    this.examDate,
    this.to,
    this.studentId,
    this.feedDate,
    this.circularId,
    this.description,
    this.file,
    this.assignId
  });

  String? type;
  String? title;
  String? academic;
  String? status;
  DateTime? examDate;
  String? to;
  String? studentId;
  DateTime? feedDate;
  String? circularId;
  String? description;
  String? assignId;
  String? file;

  factory DashboardItem.fromJson(Map<String, dynamic> json) => DashboardItem(
    type: json["type"],
    title: json["title"],
    academic: json["academic"] == null ? null : json["academic"],
    status: json["status"] == null ? null : json["status"],
    examDate: json["exam_date"] == null ? null : DateTime.parse(json["exam_date"]),
    to: json["to"],
    studentId: json["student_id"] == null ? null : json["student_id"],
    feedDate: DateTime.parse(json["feed_date"]),
    circularId: json["circular_id"] == null ? null : json["circular_id"],
    assignId: json["assignment_id"] == null ? null : json["assignment_id"],
    description: json["description"] == null ? null : json["description"],
    file: json["file"] == null ? null : json["file"],
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
