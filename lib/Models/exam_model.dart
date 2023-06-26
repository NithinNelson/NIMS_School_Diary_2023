import 'package:flutter/material.dart';

class ExamModel {
  String? queId;
  String? publishedDate;
  String? activityName;
  String? subName;
  List? themes;
  String? markObt;
  String? maxMark;
  String? type;

  ExamModel({this.themes,this.type,this.markObt,this.maxMark,this.subName,this.activityName,this.publishedDate,this.queId,});
}