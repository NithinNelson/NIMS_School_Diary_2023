import 'package:flutter/material.dart';

import '../../Widgets/report_widget.dart';

class ReportSubScreen extends StatelessWidget {
  final String? usrId;
  final String? sclId;
  final String? acdYear;
  const ReportSubScreen({Key? key,this.usrId,this.sclId,this.acdYear}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        EachReport(),
        EachReport()
      ],
    );
  }
}
