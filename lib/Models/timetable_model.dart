class TimeTableModel {
  TimeTableModel({
    this.status,
    this.data,
  });

  Status? status;
  Data? data;

  factory TimeTableModel.fromJson(Map<String, dynamic> json) => TimeTableModel(
        status: Status.fromJson(json["status"]),
        data: Data.fromJson(json["data"]),
      );

// Map<String, dynamic> toJson() => {
//   "status": status.toJson(),
//   "data": data.toJson(),
// };
}

class Data {
  Data({
    this.timetable,
    this.message,
  });

  Details? timetable;
  String? message;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json["message"],
        timetable: Details.fromJson(json["timetable"]),
      );

// Map<String, dynamic> toJson() => {
//   "message": message,
//   "timetable": timetable.toJson(),
// };
}

class Details {
  Details({this.weekdays});

  List<Weekdays>? weekdays;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        weekdays: List<Weekdays>.from(json["weekdays"].map((x) => Weekdays.fromJson(x))),
      );
}

class Weekdays {
  Weekdays({
    this.id,
    this.name,
    this.periods,
  });

  int? id;
  String? name;
  List<Periods>? periods;

  factory Weekdays.fromJson(Map<String, dynamic> json) => Weekdays(
    id: json["_id"],
    name: json["name"],
    periods: List<Periods>.from(json["periods"].map((x) => Periods.fromJson(x))),
  );
}

class Periods {
  Periods({
    this.name,
    this.nonteachingPeriod,
    this.startTime,
    this.endTime,
    this.id,
    this.periodNumber,
    this.teacherName,
    this.subjectColor,
    this.subjectName,
});

  String? name;
  bool? nonteachingPeriod;
  String? startTime;
  String? endTime;
  String? id;
  int? periodNumber;
  String? teacherName;
  String? subjectColor;
  String? subjectName;

  factory Periods.fromJson(Map<String, dynamic> json) => Periods(
    name: json["name"],
    nonteachingPeriod: json["nonteaching_period"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    id: json["_id"],
    periodNumber: json["period_number"],
    teacherName: json["teacher_name"] ?? "",
    subjectColor: json["subject_color"] ?? "",
    subjectName: json["subject_name"] ?? "",
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

// Map<String, dynamic> toJson() => {
//   "code": code,
//   "message": message,
// };
}
