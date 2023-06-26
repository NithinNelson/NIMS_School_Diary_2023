// To parse this JSON data, do
//
//     final assignment = assignmentFromJson(jsonString);

import 'dart:convert';

Assignment assignmentFromJson(String str) => Assignment.fromJson(json.decode(str));

// String assignmentToJson(Assignment data) => json.encode(data.toJson());

class Assignment {
  Assignment({
    this.status,
    this.data,
  });

  Status? status;
  AssignData? data;

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    status: Status.fromJson(json["status"]),
    data: AssignData.fromJson(json["data"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "status": status.toJson(),
  //   "data": data.toJson(),
  // };
}

class AssignData {
  AssignData({
    this.message,
    this.details,
    this.parent,
    this.child,
  });

  String? message;
  List<AssignDetails>? details;
  List<dynamic>? parent;
  List<AssignDetails>? child;

  factory AssignData.fromJson(Map<String, dynamic> json) => AssignData(
    message: json["message"],
    details: List<AssignDetails>.from(json["details"].map((x) => AssignDetails.fromJson(x))),
    parent: List<dynamic>.from(json["parent"].map((x) => x)),
    child: List<AssignDetails>.from(json["child"].map((x) => AssignDetails.fromJson(x))),
  );

  // Map<String, dynamic> toJson() => {
  //   "message": message,
  //   "details": List<dynamic>.from(details.map((x) => x.toJson())),
  //   "parent": List<dynamic>.from(parent.map((x) => x)),
  //   "child": List<dynamic>.from(child.map((x) => x.toJson())),
  // };
}

class AssignDetails {
  AssignDetails({
    this.id,
    this.attachments,
    this.title,
    this.description,
    this.file,
    this.dateAdded,
    this.sendBy,
    this.type,
    this.childId,
    this.announcementForChild,
    this.senderName,
    this.className,
    this.batchName,
    this.weblink,
  });

  String? id;
  List<String>? attachments;
  String? title;
  String? description;
  String? file;
  DateTime? dateAdded;
  String? sendBy;
  String? type;
  String? childId;
  bool? announcementForChild;
  String? senderName;
  String? className;
  String? batchName;
  String? weblink;

  factory AssignDetails.fromJson(Map<String, dynamic> json) => AssignDetails(
    id: json["_id"],
    attachments: List<String>.from(json["attachments"].map((x) => x)),
    title: json["title"],
    description: json["description"],
    file: json["file"],
    dateAdded: DateTime.parse(json["date_added"]),
    sendBy: json["send_by"],
    type: json["type"],
    childId: json["child_id"],
    announcementForChild: json["announcement_for_child"],
    senderName: json["sender_name"],
    className: json["class_name"],
    batchName: json["batch_name"],
    weblink: json["weblink"] == null ? null : json["weblink"],
  );

  // Map<String, dynamic> toJson() => {
  //   "_id": id,
  //   "attachments": List<dynamic>.from(attachments.map((x) => x)),
  //   "title": title,
  //   "description": description,
  //   "file": file,
  //   "date_added": dateAdded.toIso8601String(),
  //   "send_by": sendBy,
  //   "type": type,
  //   "child_id": childId,
  //   "announcement_for_child": announcementForChild,
  //   "sender_name": senderName,
  //   "class_name": className,
  //   "batch_name": batchName,
  //   "weblink": weblink == null ? null : weblink,
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

  // Map<String, dynamic> toJson() => {
  //   "code": code,
  //   "message": message,
  // };
}
