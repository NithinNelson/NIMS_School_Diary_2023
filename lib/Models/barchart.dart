import 'dart:ui';

class ChartData{
  ChartData({this.xaxis,this.yaxis,this.colr});
  final String? xaxis;
  final double? yaxis;
  final Color? colr;
}

class ComparisonChart {
  ComparisonChart({this.xaxis,this.y1,this.y2});
  final String? xaxis;
  final double? y1;
  final double? y2;
}