// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

//String reportToJson(Report data) => json.encode(data.toJson());

class Report {
  Report({
    this.status,
    this.data,
  });

  Status? status;
  Data? data;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
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
    this.initLoad,
    this.fetureRoles,
    this.arrayToClient,
    this.currentDate,
    this.myData,
  });

  InitLoad? initLoad;
  List<String>? fetureRoles;
  List<ArrayToClient>? arrayToClient;
  DateTime? currentDate;
  dynamic myData;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    initLoad: InitLoad.fromJson(json["initLoad"]),
    fetureRoles: List<String>.from(json["fetureRoles"].map((x) => x)),
    arrayToClient: List<ArrayToClient>.from(json["arrayToClient"].map((x) => ArrayToClient.fromJson(x))),
    currentDate: DateTime.parse(json["currentDate"]),
    myData: json["my_data"],
  );

  // Map<String, dynamic> toJson() => {
  //   "initLoad": initLoad.toJson(),
  //   "fetureRoles": List<dynamic>.from(fetureRoles.map((x) => x)),
  //   "arrayToClient": List<dynamic>.from(arrayToClient.map((x) => x.toJson())),
  //   "currentDate": currentDate.toIso8601String(),
  //   "my_data": myData,
  // };
}

class ArrayToClient {
  ArrayToClient({
    this.reportConsoleId,
    this.name,
    this.academics,
    this.lastUpdated,
    this.document,
    this.assetsDoc,
  });

  String? reportConsoleId;
  String? name;
  String? academics;
  DateTime? lastUpdated;
  String? document;
  String? assetsDoc;

  factory ArrayToClient.fromJson(Map<String, dynamic> json) => ArrayToClient(
    reportConsoleId: json["report_console_id"],
    name: json["name"],
    academics: json["academics"],
    lastUpdated: DateTime.parse(json["last_updated"]),
    document: json["document"] == null ? null : json["document"],
    assetsDoc: json["assets_doc"] == null ? null : json["assets_doc"],
  );

  // Map<String, dynamic> toJson() => {
  //   "report_console_id": reportConsoleId,
  //   "name": name,
  //   "academics": academics,
  //   "last_updated": lastUpdated.toIso8601String(),
  //   "document": document == null ? null : document,
  //   "assets_doc": assetsDoc == null ? null : assetsDoc,
  // };
}

class InitLoad {
  InitLoad({
    this.id,
    this.roleIds,
    this.emails,
    this.services,
    this.educoreId,
    this.updatedOn,
    this.email,
    this.updatedBy,
    this.v,
    this.schoolId,
    this.roleId,
    this.defaultRole,
    this.username,
    this.name,
    this.phone,
    this.addrLine1,
    this.addrLine2,
    this.city,
    this.country,
    this.pincode,
    this.bloodGroup,
    this.setPrivacy,
    this.academicYear,
    this.parentObj,
    this.sex,
    this.birthDate,
    this.joinedDate,
    this.admissionNumber,
    this.spouseName,
    this.relation,
    this.gsuitData,
    this.notificationTracking,
    this.passwordTracking,
    this.isBmUpdate,
    this.image,
    this.displayName,
    this.school,
  });

  String? id;
  List<String>? roleIds;
  List<EmailElement>? emails;
  List<Service>? services;
  List<String>? educoreId;
  DateTime? updatedOn;
  String? email;
  String? updatedBy;
  int? v;
  String? schoolId;
  String? roleId;
  String? defaultRole;
  String? username;
  String? name;
  String? phone;
  String? addrLine1;
  String? addrLine2;
  String? city;
  String? country;
  String? pincode;
  String? bloodGroup;
  SetPrivacy? setPrivacy;
  String? academicYear;
  ParentObj? parentObj;
  String? sex;
  DateTime? birthDate;
  DateTime? joinedDate;
  String? admissionNumber;
  String? spouseName;
  String? relation;
  GsuitData? gsuitData;
  DateTime? notificationTracking;
  DateTime? passwordTracking;
  bool? isBmUpdate;
  Image? image;
  String? displayName;
  List<School>? school;

  factory InitLoad.fromJson(Map<String, dynamic> json) => InitLoad(
    id: json["_id"],
    roleIds: List<String>.from(json["role_ids"].map((x) => x)),
    emails: List<EmailElement>.from(json["emails"].map((x) => EmailElement.fromJson(x))),
    services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
    educoreId: List<String>.from(json["educore_id"].map((x) => x)),
    updatedOn: DateTime.parse(json["updated_on"]),
    email: json["email"],
    updatedBy: json["updated_by"],
    v: json["__v"],
    schoolId: json["school_id"],
    roleId: json["role_id"],
    defaultRole: json["default_role"],
    username: json["username"],
    name: json["name"],
    phone: json["phone"],
    addrLine1: json["addrLine1"],
    addrLine2: json["addrLine2"],
    city: json["city"],
    country: json["country"],
    pincode: json["pincode"],
    bloodGroup: json["blood_group"],
    setPrivacy: SetPrivacy.fromJson(json["set_privacy"]),
    academicYear: json["academic_year"],
    parentObj: ParentObj.fromJson(json["parent_obj"]),
    sex: json["sex"],
    birthDate: DateTime.parse(json["birth_date"]),
    joinedDate: DateTime.parse(json["joined_date"]),
    admissionNumber: json["admission_number"],
    spouseName: json["spouse_name"],
    relation: json["relation"],
    gsuitData: GsuitData.fromJson(json["gsuit_data"]),
    notificationTracking: DateTime.parse(json["notification_tracking"]),
    passwordTracking: DateTime.parse(json["password_tracking"]),
    isBmUpdate: json["_isBmUpdate"],
    image: Image.fromJson(json["image"]),
    displayName: json["display_name"],
    school: List<School>.from(json["school"].map((x) => School.fromJson(x))),
  );

  // Map<String, dynamic> toJson() => {
  //   "_id": id,
  //   "role_ids": List<dynamic>.from(roleIds.map((x) => x)),
  //   "emails": List<dynamic>.from(emails.map((x) => x.toJson())),
  //   "services": List<dynamic>.from(services.map((x) => x.toJson())),
  //   "educore_id": List<dynamic>.from(educoreId.map((x) => x)),
  //   "updated_on": updatedOn.toIso8601String(),
  //   "email": email,
  //   "updated_by": updatedBy,
  //   "__v": v,
  //   "school_id": schoolId,
  //   "role_id": roleId,
  //   "default_role": defaultRole,
  //   "username": username,
  //   "name": name,
  //   "phone": phone,
  //   "addrLine1": addrLine1,
  //   "addrLine2": addrLine2,
  //   "city": city,
  //   "country": country,
  //   "pincode": pincode,
  //   "blood_group": bloodGroup,
  //   "set_privacy": setPrivacy.toJson(),
  //   "academic_year": academicYear,
  //   "parent_obj": parentObj.toJson(),
  //   "sex": sex,
  //   "birth_date": "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
  //   "joined_date": "${joinedDate.year.toString().padLeft(4, '0')}-${joinedDate.month.toString().padLeft(2, '0')}-${joinedDate.day.toString().padLeft(2, '0')}",
  //   "admission_number": admissionNumber,
  //   "spouse_name": spouseName,
  //   "relation": relation,
  //   "gsuit_data": gsuitData.toJson(),
  //   "notification_tracking": notificationTracking.toIso8601String(),
  //   "password_tracking": passwordTracking.toIso8601String(),
  //   "_isBmUpdate": isBmUpdate,
  //   "image": image.toJson(),
  //   "display_name": displayName,
  //   "school": List<dynamic>.from(school.map((x) => x.toJson())),
  // };
}

class EmailElement {
  EmailElement({
    this.address,
    this.verified,
  });

  String? address;
  bool? verified;

  factory EmailElement.fromJson(Map<String, dynamic> json) => EmailElement(
    address: json["address"],
    verified: json["verified"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "verified": verified,
  };
}

class GsuitData {
  GsuitData({
    this.id,
    this.email,
    this.verifiedEmail,
    this.name,
    this.givenName,
    this.familyName,
    this.picture,
    this.locale,
    this.hd,
    this.result,
  });

  String? id;
  String? email;
  bool? verifiedEmail;
  String? name;
  String? givenName;
  String? familyName;
  String? picture;
  String? locale;
  String? hd;
  GsuitData? result;

  factory GsuitData.fromJson(Map<String, dynamic> json) => GsuitData(
    id: json["id"],
    email: json["email"],
    verifiedEmail: json["verified_email"],
    name: json["name"],
    givenName: json["given_name"],
    familyName: json["family_name"],
    picture: json["picture"],
    locale: json["locale"],
    hd: json["hd"],
    result: json["result"] == null ? null : GsuitData.fromJson(json["result"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "email": email,
  //   "verified_email": verifiedEmail,
  //   "name": name,
  //   "given_name": givenName,
  //   "family_name": familyName,
  //   "picture": picture,
  //   "locale": locale,
  //   "hd": hd,
  //   "result": result == null ? null : result.toJson(),
  // };
}

class Image {
  Image({
    this.original,
  });

  String? original;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    original: json["original"],
  );

  Map<String, dynamic> toJson() => {
    "original": original,
  };
}

class ParentObj {
  ParentObj({
    this.email,
    this.relation,
    this.mapped,
    this.spouse,
  });

  String? email;
  String? relation;
  bool? mapped;
  String? spouse;

  factory ParentObj.fromJson(Map<String, dynamic> json) => ParentObj(
    email: json["email"],
    relation: json["relation"],
    mapped: json["mapped"],
    spouse: json["spouse"],
  );

  // Map<String, dynamic> toJson() => {
  //   "email": email,
  //   "relation": relation,
  //   "mapped": mapped,
  //   "spouse": spouse,
  // };
}

class School {
  School({
    this.id,
    this.schoolName,
    this.description,
    this.address,
    this.domain,
    this.phone,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.academicYear,
    this.numberofUsers,
    this.educoreId,
    this.initialView,
    this.email,
    this.logo,
    this.weekEnd,
    this.updatedOn,
    this.updatedBy,
    this.googleSheetFolderId,
    this.bannerStatus,
    this.senderAddress,
  });

  String? id;
  String? schoolName;
  String? description;
  String? address;
  Domain? domain;
  String? phone;
  DateTime? subscriptionStartDate;
  DateTime? subscriptionEndDate;
  List<AcademicYear>? academicYear;
  int? numberofUsers;
  List<EducoreId>? educoreId;
  int? initialView;
  SchoolEmail? email;
  String? logo;
  dynamic weekEnd;
  DateTime? updatedOn;
  String? updatedBy;
  String? googleSheetFolderId;
  bool? bannerStatus;
  String? senderAddress;

  factory School.fromJson(Map<String, dynamic> json) => School(
    id: json["_id"],
    schoolName: json["school_name"],
    description: json["description"],
    address: json["address"],
    domain: Domain.fromJson(json["domain"]),
    phone: json["phone"],
    subscriptionStartDate: DateTime.parse(json["subscription_start_date"]),
    subscriptionEndDate: DateTime.parse(json["subscription_end_date"]),
    academicYear: List<AcademicYear>.from(json["academic_year"].map((x) => AcademicYear.fromJson(x))),
    numberofUsers: json["numberof_users"],
    educoreId: List<EducoreId>.from(json["educore_id"].map((x) => EducoreId.fromJson(x))),
    initialView: json["initialView"],
    email: SchoolEmail.fromJson(json["email"]),
    logo: json["logo"],
    weekEnd: json["week_end"],
    updatedOn: DateTime.parse(json["updated_on"]),
    updatedBy: json["updated_by"],
    googleSheetFolderId: json["google_sheet_folder_id"],
    bannerStatus: json["banner_status"],
    senderAddress: json["senderAddress"],
  );

  // Map<String, dynamic> toJson() => {
  //   "_id": id,
  //   "school_name": schoolName,
  //   "description": description,
  //   "address": address,
  //   "domain": domain.toJson(),
  //   "phone": phone,
  //   "subscription_start_date": subscriptionStartDate.toIso8601String(),
  //   "subscription_end_date": subscriptionEndDate.toIso8601String(),
  //   "academic_year": List<dynamic>.from(academicYear.map((x) => x.toJson())),
  //   "numberof_users": numberofUsers,
  //   "educore_id": List<dynamic>.from(educoreId.map((x) => x.toJson())),
  //   "initialView": initialView,
  //   "email": email.toJson(),
  //   "logo": logo,
  //   "week_end": weekEnd,
  //   "updated_on": updatedOn.toIso8601String(),
  //   "updated_by": updatedBy,
  //   "google_sheet_folder_id": googleSheetFolderId,
  //   "banner_status": bannerStatus,
  //   "senderAddress": senderAddress,
  // };
}

class AcademicYear {
  AcademicYear({
    this.id,
    this.year,
    this.status,
    this.startDate,
  });

  String? id;
  String? year;
  String? status;
  DateTime? startDate;

  factory AcademicYear.fromJson(Map<String, dynamic> json) => AcademicYear(
    id: json["_id"],
    year: json["year"],
    status: json["status"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "_id": id,
  //   "year": year,
  //   "status": status,
  //   "start_date": startDate == null ? null : startDate.toIso8601String(),
  // };
}

class Domain {
  Domain({
    this.name,
  });

  Name? name;

  factory Domain.fromJson(Map<String, dynamic> json) => Domain(
    name: Name.fromJson(json["name"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "name": name.toJson(),
  // };
}

class Name {
  Name({
    this.name,
  });

  String? name;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
    name: json["name"],
  );

  // Map<String, dynamic> toJson() => {
  //   "name": name,
  // };
}

class EducoreId {
  EducoreId({
    this.seqCode,
    this.start,
    this.end,
    this.lastInsertId,
  });

  String? seqCode;
  int? start;
  int? end;
  int? lastInsertId;

  factory EducoreId.fromJson(Map<String, dynamic> json) => EducoreId(
    seqCode: json["seq_code"],
    start: json["start"],
    end: json["end"],
    lastInsertId: json["last_insert_id"],
  );

  // Map<String, dynamic> toJson() => {
  //   "seq_code": seqCode,
  //   "start": start,
  //   "end": end,
  //   "last_insert_id": lastInsertId,
  // };
}

class SchoolEmail {
  SchoolEmail({
    this.address1,
  });

  String? address1;

  factory SchoolEmail.fromJson(Map<String, dynamic> json) => SchoolEmail(
    address1: json["address1"],
  );

  Map<String, dynamic> toJson() => {
    "address1": address1,
  };
}

class Service {
  Service({
    this.password,
  });

  Password? password;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    password: Password.fromJson(json["password"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "password": password.toJson(),
  // };
}

class Password {
  Password({
    this.bcrypt,
    this.reset,
  });

  String? bcrypt;
  Reset? reset;

  factory Password.fromJson(Map<String, dynamic> json) => Password(
    bcrypt: json["bcrypt"],
    reset: Reset.fromJson(json["reset"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "bcrypt": bcrypt,
  //   "reset": reset.toJson(),
  // };
}

class Reset {
  Reset({
    this.token,
    this.email,
    this.when,
    this.reason,
  });

  String? token;
  String? email;
  DateTime? when;
  String? reason;

  factory Reset.fromJson(Map<String, dynamic> json) => Reset(
    token: json["token"],
    email: json["email"],
    when: DateTime.parse(json["when"]),
    reason: json["reason"],
  );

  // Map<String, dynamic> toJson() => {
  //   "token": token,
  //   "email": email,
  //   "when": when.toIso8601String(),
  //   "reason": reason,
  // };
}

class SetPrivacy {
  SetPrivacy({
    this.username,
    this.phone,
    this.addrLine1,
    this.addrLine2,
    this.city,
    this.country,
    this.pincode,
    this.bloodGroup,
  });

  bool? username;
  bool? phone;
  bool? addrLine1;
  bool? addrLine2;
  bool? city;
  bool? country;
  bool? pincode;
  bool? bloodGroup;

  factory SetPrivacy.fromJson(Map<String, dynamic> json) => SetPrivacy(
    username: json["username"],
    phone: json["phone"],
    addrLine1: json["addrLine1"],
    addrLine2: json["addrLine2"],
    city: json["city"],
    country: json["country"],
    pincode: json["pincode"],
    bloodGroup: json["blood_group"],
  );

  // Map<String, dynamic> toJson() => {
  //   "username": username,
  //   "phone": phone,
  //   "addrLine1": addrLine1,
  //   "addrLine2": addrLine2,
  //   "city": city,
  //   "country": country,
  //   "pincode": pincode,
  //   "blood_group": bloodGroup,
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
