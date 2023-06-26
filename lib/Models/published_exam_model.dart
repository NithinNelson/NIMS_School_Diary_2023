// To parse this JSON data, do
//
//     final published = publishedFromJson(jsonString);

import 'dart:convert';

Published publishedFromJson(String str) => Published.fromJson(json.decode(str));

String publishedToJson(Published data) => json.encode(data.toJson());

class Published {
  Published({
    this.id,
    this.activityId,
    this.totalMark,
    this.startTime,
    this.endTime,
    this.dueDate,
    this.activityName,
    this.themeNames,
    this.status,
    this.activityStatus,
    this.totalQuestion,
    this.subjectName,
    this.mark,
    this.attendedQuestion,
  });

  String? id;
  String? activityId;
  int? totalMark;
  String? startTime;
  String? endTime;
  String? dueDate;
  String? activityName;
  List<String>? themeNames;
  String? status;
  String? activityStatus;
  int? totalQuestion;
  String? subjectName;
  int? mark;
  int? attendedQuestion;

  factory Published.fromJson(Map<String, dynamic> json) => Published(
    id: json["_id"],
    activityId: json["activity_id"],
    totalMark: json["total_mark"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    dueDate: json["due_date"],
    activityName: json["activity_name"],
    themeNames: List<String>.from(json["theme_names"].map((x) => x)),
    status: json["status"],
    activityStatus: json["activity_status"],
    totalQuestion: json["total_question"],
    subjectName: json["subject_name"],
    mark: json["mark"],
    attendedQuestion: json["attended_question"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "activity_id": activityId,
    "total_mark": totalMark,
    "start_time": startTime,
    "end_time": endTime,
    "due_date": dueDate,
    "activity_name": activityName,
    "theme_names": List<dynamic>.from(themeNames!.map((x) => x)),
    "status": status,
    "activity_status": activityStatus,
    "total_question": totalQuestion,
    "subject_name": subjectName,
    "mark": mark,
    "attended_question": attendedQuestion,
  };
}
