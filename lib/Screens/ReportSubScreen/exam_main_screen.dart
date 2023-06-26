import 'package:flutter/material.dart';

class ExamScreen extends StatelessWidget {
  final String? schoolId;
  final String? acadYear;
  final String? curriculumId;
  final String? batchId;
  final String? studId;
  final String? sessionId;
  final String? classId;
  const ExamScreen({Key? key,this.sessionId,this.curriculumId,this.classId,this.batchId,this.schoolId,this.acadYear,this.studId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(schoolId.toString()),
        Text(acadYear.toString()),
        Text(curriculumId.toString()),
        Text(batchId.toString()),
        Text(studId.toString()),
        Text(sessionId.toString()),
        Text(classId.toString())
      ],
    );
  }
}
