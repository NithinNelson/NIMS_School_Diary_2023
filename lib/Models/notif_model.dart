// To parse this JSON data, do
//
//     final notifications = notificationsFromJson(jsonString);

import 'dart:convert';

Notifications notificationsFromJson(String str) => Notifications.fromJson(json.decode(str));

// String notificationsToJson(Notifications data) => json.encode(data.toJson());

class Notifications {
  Notifications({
    this.status,
    this.data,
  });

  StatusClass? status;
  Data? data;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    status: StatusClass.fromJson(json["status"]),
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
    this.details,
  });

  String? message;
  Details? details;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
    details: Details.fromJson(json["details"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "message": message,
  //   "details": details.toJson(),
  // };
}

class Details {
  Details({
    this.allNotifications,
    this.allNotificationsCount,
  });

  List<AllNotification>? allNotifications;
  int? allNotificationsCount;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    allNotifications: List<AllNotification>.from(json["allNotifications"].map((x) => AllNotification.fromJson(x))),
    allNotificationsCount: json["allNotificationsCount"],
  );

  // Map<String, dynamic> toJson() => {
  //   "allNotifications": List<dynamic>.from(allNotifications!.map((x) => x.toJson())),
  //   "allNotificationsCount": allNotificationsCount,
  // };
}

class AllNotification {
  AllNotification({
    this.id,
    this.updatedOn,
    this.references,
    this.type,
    this.iconType,
    this.status,
    this.msg,
    this.genDate,
    this.senderId,
    this.updatedBy,
    this.date,
    this.recipient,
  });

  String? id;
  DateTime? updatedOn;
  References? references;
  int? type;
  int? iconType;
  StatusEnum? status;
  String? msg;
  DateTime? genDate;
  SenderId? senderId;
  SenderId? updatedBy;
  DateTime? date;
  Recipient? recipient;

  factory AllNotification.fromJson(Map<String, dynamic> json) => AllNotification(
    id: json["_id"],
    updatedOn: DateTime.parse(json["updated_on"]),
    references: json["references"] == null ? null : References.fromJson(json["references"]),
    type: json["type"],
    iconType: json["icon_type"],
    status: statusEnumValues.map![json["status"]],
    msg: json["msg"],
    genDate: DateTime.parse(json["gen-date"]),
    senderId: senderIdValues.map![json["sender_id"]],
    updatedBy: senderIdValues.map![json["updated_by"]],
    date: DateTime.parse(json["date"]),
    recipient: json["recipient"] == null ? null : Recipient.fromJson(json["recipient"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "_id": id,
  //   "updated_on": updatedOn.toIso8601String(),
  //   "references": references == null ? null : references.toJson(),
  //   "type": type,
  //   "icon_type": iconType,
  //   "status": statusEnumValues.reverse[status],
  //   "msg": msg,
  //   "gen-date": genDate.toIso8601String(),
  //   "sender_id": senderIdValues.reverse[senderId],
  //   "updated_by": senderIdValues.reverse[updatedBy],
  //   "date": date.toIso8601String(),
  //   "recipient": recipient == null ? null : recipient.toJson(),
  // };
}

class Recipient {
  Recipient({
    this.id,
  });

  List<String>? id;

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
    id: List<String>.from(json["_id"].map((x) => x)),
  );

  // Map<String, dynamic> toJson() => {
  //   "_id": List<dynamic>.from(id.map((x) => x)),
  // };
}

class References {
  References({
    this.studentId,
  });

  String? studentId;

  factory References.fromJson(Map<String, dynamic> json) => References(
    studentId: json["student_id"],
  );

  Map<String, dynamic> toJson() => {
    "student_id": studentId,
  };
}

enum SenderId { THE_44_B7_TVZ_RT_ZKPDXS9_U, GQR4_BA63_EQN9_OH3_W_L, F_JDTWN_Y_CKAF63_O_NAL, THE_8_EV_DB_DR32_C_D_TERA_CG, THE_5_D0_A0750_A0033_F3237_AACF27 }

final senderIdValues = EnumValues({
  "FJdtwnYCkaf63oNAL": SenderId.F_JDTWN_Y_CKAF63_O_NAL,
  "Gqr4ba63Eqn9oh3wL": SenderId.GQR4_BA63_EQN9_OH3_W_L,
  "44B7TvzRTZkpdxs9u": SenderId.THE_44_B7_TVZ_RT_ZKPDXS9_U,
  "5d0a0750a0033f3237aacf27": SenderId.THE_5_D0_A0750_A0033_F3237_AACF27,
  "8EvDbDR32cDTeraCg": SenderId.THE_8_EV_DB_DR32_C_D_TERA_CG
});

enum StatusEnum { ACTIVE, INACTIVE }

final statusEnumValues = EnumValues({
  "active": StatusEnum.ACTIVE,
  "inactive": StatusEnum.INACTIVE
});

class StatusClass {
  StatusClass({
    this.code,
    this.message,
  });

  int? code;
  String? message;

  factory StatusClass.fromJson(Map<String, dynamic> json) => StatusClass(
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
