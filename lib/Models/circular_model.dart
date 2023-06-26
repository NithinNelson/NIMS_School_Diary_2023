// To parse this JSON data, do
//
//     final circular = circularFromJson(jsonString);

import 'dart:convert';

Circular circularFromJson(String str) => Circular.fromJson(json.decode(str));



class Circular {
  Circular({
    this.status,
    this.data,
  });

  Status? status;
  Data? data;

  factory Circular.fromJson(Map<String, dynamic> json) => Circular(
    status: Status.fromJson(json["status"]),
    data: Data.fromJson(json["data"]),
  );


}

class Data {
  Data({
    this.message,
    this.details,
    this.parent,
    this.child,
  });

  String? message;
  List<Detail>? details;
  List<Detail>? parent;
  List<Detail>? child;
  //List<dynamic>? child;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
    details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    parent: List<Detail>.from(json["parent"].map((x) => Detail.fromJson(x))),
    child: List<Detail>.from(json["child"].map((x) => Detail.fromJson(x))),
    //child: List<dynamic>.from(json["child"].map((x) => x)),
  );


}

class Detail {
  Detail({
    this.id,
    this.attachments,
    this.title,
    this.description,
    this.file,
    this.weblink,
    this.dateAdded,
    this.sendBy,
    this.type,
    this.senderName,
  });

  String? id;
  List<String>? attachments;
  String? title;
  String? description;
  String? file;
  String? weblink;
  DateTime? dateAdded;
  String? sendBy;
  String? type;
  String? senderName;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["_id"],
    attachments: List<String>.from(json["attachments"].map((x) => x)),
    title: json["title"],
    description: json["description"],
    file: json["file"],
    weblink: json["weblink"],
    dateAdded: DateTime.parse(json["date_added"]),
    sendBy: json["send_by"],
    type: json["type"],
    senderName: json["sender_name"],
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

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}


