// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

HtModel welcomeFromJson(String str) => HtModel.fromJson(json.decode(str));

// String welcomeToJson(Welcome data) => json.encode(data.toJson());

class HtModel {
  HtModel({
    this.status,
    this.data,
  });

  Status? status;
  Data? data;

  factory HtModel.fromJson(Map<String, dynamic> json) => HtModel(
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
    this.message,
    this.htData,
  });

  String? message;
  List<HallTicketData>? htData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
    htData: List<HallTicketData>.from(json["data"].map((x) => HallTicketData.fromJson(x))),
  );

  // Map<String, dynamic> toJson() => {
  //   "message": message,
  //   "data": List<dynamic>.from(htData.map((x) => x.toJson())),
  // };
}

class HallTicketData {
  HallTicketData({
    this.examName,
    this.gneratedOn,
    this.pdf,
  });

  String? examName;
  DateTime? gneratedOn;
  String? pdf;

  factory HallTicketData.fromJson(Map<String, dynamic> json) => HallTicketData(
    examName: json["exam_name"],
    gneratedOn: DateTime.parse(json["gnerated_on"]),
    pdf: json["pdf"],
  );

  // Map<String, dynamic> toJson() => {
  //   "exam_name": examName,
  //   "gnerated_on": gneratedOn.toIso8601String(),
  //   "pdf": pdf,
  // };
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
