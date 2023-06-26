// To parse this JSON data, do
//
//     final calendarEvents = calendarEventsFromJson(jsonString);

import 'dart:convert';

CalendarEvents calendarEventsFromJson(String str) => CalendarEvents.fromJson(json.decode(str));



class CalendarEvents {
  CalendarEvents({
    this.status,
    this.data,
  });

  Status? status;
  CalendarEventsData? data;

  factory CalendarEvents.fromJson(Map<String, dynamic> json) => CalendarEvents(
    status: Status.fromJson(json["status"]),
    data: CalendarEventsData.fromJson(json["data"]),
  );


}

class CalendarEventsData {
  CalendarEventsData({
    this.message,
    this.data,
  });

  String? message;
  AttendanceData? data;

  factory CalendarEventsData.fromJson(Map<String, dynamic> json) => CalendarEventsData(
    message: json["message"],
    data: AttendanceData.fromJson(json["data"]),
  );


}

class AttendanceData {
  AttendanceData({
    this.message,
    this.monthattendance,
    this.fullattendance,
    this.calendar,
    this.today,
  });

  String? message;
  List<Attendance>? monthattendance;
  Attendance? fullattendance;
  List<CalendarClass>? calendar;
  DateTime? today;

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
    message: json["message"],
    monthattendance: List<Attendance>.from(json["monthattendance"].map((x) => Attendance.fromJson(x))),
    fullattendance: Attendance.fromJson(json["fullattendance"]),
    calendar: List<CalendarClass>.from(json["calendar"].map((x) => CalendarClass.fromJson(x))),
    today: DateTime.parse(json["today"]),
  );


}

class CalendarClass {
  CalendarClass({
    this.id,
    this.date,
    this.color,
    this.calendar,
    this.partial,
    this.eventName,
    this.endFormat,
    this.startDate,
    this.endDate,
    this.startFormatValues,
    this.endFormatValues,
    this.diffState,
    this.diffDates,
   // this.allClasses
  });

  String? id;
  DateTime? date;
  EventColor? color;
  EventNameElement? calendar;
  bool? partial;
  dynamic eventName;
  DateTime? endFormat;
  DateTime? startDate;
  DateTime? endDate;
  String? startFormatValues;
  String? endFormatValues;
  bool? diffState;
  int? diffDates;
  //AllClasses? allClasses;
  factory CalendarClass.fromJson(Map<String, dynamic> json) => CalendarClass(
    id: json["_id"],
    //date: DateTime.parse(json["date"]),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    color: colorValues.map![json["color"]],
    calendar: eventNameElementValues.map![json["calendar"]],
    partial: json["partial"] == null ? null : json["partial"],
    eventName: json["eventName"],
    endFormat: json["end_format"] == null ? null : DateTime.parse(json["end_format"]),
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    startFormatValues: json["start_format_values"] == null ? null : json["start_format_values"],
    endFormatValues: json["end_format_values"] == null ? null : json["end_format_values"],
    diffState: json["diff_state"] == null ? null : json["diff_state"],
    diffDates: json["diff_dates"] == null ? null : json["diff_dates"],
    //allClasses: allClassesValues.map![json["allClasses"]]!,
  );


}
enum AllClasses { YES,NO }

final allClassesValues = EnumValues({
  "yes": AllClasses.YES,
  "no": AllClasses.NO
});
enum EventNameElement { PRESENT, ABSENT,HOLIDAY, EVENTS , EXAM}

final eventNameElementValues = EnumValues({
  "Absent": EventNameElement.ABSENT,
  "Holiday": EventNameElement.HOLIDAY,
  "Events": EventNameElement.EVENTS,
  "Exam": EventNameElement.EXAM,
  "Present": EventNameElement.PRESENT
});

enum EventColor { GREEN, RED, BLUE }

final colorValues = EnumValues({
  "blue": EventColor.BLUE,
  "green": EventColor.GREEN,
  "red": EventColor.RED
});

class Attendance {
  Attendance({
    this.id,
    this.present,
    this.absent,
    this.leave,
    this.total,
    this.presentPercent,
    this.year
  });

  String? id;
  int? present;
  int? absent;
  int? leave;
  int? total;
  double? presentPercent;
  String? year;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    id: json["_id"],
    present: json["present"],
    absent: json["absent"],
    leave: json["leave"],
    total: json["total"],
    presentPercent: json["present_percent"] == null ? null : json["present_percent"].toDouble(),
    year: json["year"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "present": present,
    "absent": absent,
    "leave": leave,
    "total": total,
    "present_percent": presentPercent == null ? null : presentPercent,
    "year": year,
  };
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

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
