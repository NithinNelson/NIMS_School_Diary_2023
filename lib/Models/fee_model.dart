// To parse this JSON data, do
//
//     final feeDetails = feeDetailsFromJson(jsonString);

import 'dart:convert';

FeeDetails feeDetailsFromJson(String str) => FeeDetails.fromJson(json.decode(str));

//String feeDetailsToJson(FeeDetails data) => json.encode(data.toJson());

class FeeDetails {
  FeeDetails({
    this.status,
    this.data,
  });

  Status? status;
  Data? data;

  factory FeeDetails.fromJson(Map<String, dynamic> json) => FeeDetails(
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
    this.feePaidData,
    this.exemptionList,
  });

  String? message;
  List<FeeTotalDetails>? details;
  Map<String, FeePaidDatum>? feePaidData;
  List<String>? exemptionList;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
    details: List<FeeTotalDetails>.from(json["details"].map((x) => FeeTotalDetails.fromJson(x))),
    feePaidData: Map.from(json["fee_paid_data"]).map((k, v) => MapEntry<String, FeePaidDatum>(k, FeePaidDatum.fromJson(v))),
    exemptionList: List<String>.from(json["exemption_list"].map((x) => x)),
  );

  // Map<String, dynamic> toJson() => {
  //   "message": message,
  //   "details": List<dynamic>.from(details.map((x) => x.toJson())),
  //   "fee_paid_data": Map.from(feePaidData).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  //   "exemption_list": List<dynamic>.from(exemptionList.map((x) => x)),
  // };
}

class FeeTotalDetails {
  FeeTotalDetails({
    this.feeMonth,
    this.feeTermName,
    this.feeTermDuration,
    this.feeLastDate,
    this.feeStatus,
    this.blockingStatus,
    this.feePaidOn,
    this.totalDemanded,
    this.totalPaid,
    this.totalExemption,
    this.totalConcession,
    this.balance,
    this.details,
  });

  String? feeMonth;
  String? feeTermName;
  String? feeTermDuration;
  DateTime? feeLastDate;
  String? feeStatus;
  String? blockingStatus;
  String? feePaidOn;
  String? totalDemanded;
  String? totalPaid;
  String? totalExemption;
  String? totalConcession;
  String? balance;
  Details? details;

  factory FeeTotalDetails.fromJson(Map<String, dynamic> json) => FeeTotalDetails(
    feeMonth: json["fee_month"],
    feeTermName: json["fee_term_name"],
    feeTermDuration: json["fee_term_duration"],
    feeLastDate: DateTime.parse(json["fee_last_date"]),
    feeStatus: json["fee_status"],
    blockingStatus: json["blocking_status"],
    feePaidOn: json["fee_paid_on"],
    totalDemanded: json["total_demanded"],
    totalPaid: json["total_paid"],
    totalExemption: json["total_exemption"],
    totalConcession: json["total_concession"],
    balance: json["balance"],
    details: Details.fromJson(json["details"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "fee_month": feeMonth,
  //   "fee_term_name": feeTermName,
  //   "fee_term_duration": feeTermDuration,
  //   "fee_last_date": "${feeLastDate.year.toString().padLeft(4, '0')}-${feeLastDate.month.toString().padLeft(2, '0')}-${feeLastDate.day.toString().padLeft(2, '0')}",
  //   "fee_status": feeStatus,
  //   "blocking_status": blockingStatus,
  //   "fee_paid_on": feePaidOn,
  //   "total_demanded": totalDemanded,
  //   "total_paid": totalPaid,
  //   "total_exemption": totalExemption,
  //   "total_concession": totalConcession,
  //   "balance": balance,
  //   "details": details.toJson(),
  // };
}

class Details {
  Details({
    this.total,
    this.lateFee,
    this.tuitionFees,
    this.labFees,
    this.medicalFees,
    this.resourcesFee,
    this.ibtArabicOctober,
  });

  String? total;
  int? lateFee;
  LabFees? tuitionFees;
  LabFees? labFees;
  LabFees? medicalFees;
  LabFees? resourcesFee;
  LabFees? ibtArabicOctober;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    total: json["total"],
    lateFee: json["late_fee"],
    tuitionFees: LabFees.fromJson(json["Tuition Fees"]),
    labFees: LabFees.fromJson(json["Lab Fees"]),
    medicalFees: LabFees.fromJson(json["Medical Fees"]),
    resourcesFee: LabFees.fromJson(json["Resources Fee"]),
    ibtArabicOctober: json["Ibt Arabic (October)"] == null ? null : LabFees.fromJson(json["Ibt Arabic (October)"]),
  );

  Details.map(dynamic obj){
    this.total = obj['total'];
    this.lateFee = obj['late_fee'];
    this.tuitionFees = LabFees.fromJson(obj["Lab Fees"]);
    this.labFees = LabFees.fromJson(obj["Lab Fees"]);
    this.medicalFees = LabFees.fromJson(obj["Medical Fees"]);
    this.resourcesFee = LabFees.fromJson(obj["Resources Fee"]);
    this.ibtArabicOctober = obj["Ibt Arabic (October)"] == null ? null : LabFees.fromJson(obj["Ibt Arabic (October)"]);
  }
  // Map<String, dynamic> toJson() => {
  //   "total": total,
  //   "late_fee": lateFee,
  //   "Tuition Fees": tuitionFees.toJson(),
  //   "Lab Fees": labFees.toJson(),
  //   "Medical Fees": medicalFees.toJson(),
  //   "Resources Fee": resourcesFee.toJson(),
  //   "Ibt Arabic (October)": ibtArabicOctober == null ? null : ibtArabicOctober.toJson(),
  // };
}

class LabFees {
  LabFees({
    this.balanceAmount,
    this.demandedAmount,
    this.advanceAmount,
    this.concessionAmount,
    this.excemptedAmount,
    this.excemptionPendingAmount,
    this.paidAmount,
    this.penaltyCollected,
    this.penaltyDemanded,
  });

  String? balanceAmount;
  String? demandedAmount;
  int? advanceAmount;
  String? concessionAmount;
  String? excemptedAmount;
  String? excemptionPendingAmount;
  String? paidAmount;
  String? penaltyCollected;
  String? penaltyDemanded;

  factory LabFees.fromJson(Map<String, dynamic> json) => LabFees(
    balanceAmount: json["balance_amount"],
    demandedAmount: json["demanded_amount"],
    advanceAmount: json["advance_amount"],
    concessionAmount: json["concession_amount"],
    excemptedAmount: json["excempted_amount"],
    excemptionPendingAmount: json["excemption_pending_amount"],
    paidAmount: json["paid_amount"],
    penaltyCollected: json["penalty_collected"],
    penaltyDemanded: json["penalty_demanded"],
  );

  // Map<String, dynamic> toJson() => {
  //   "balance_amount": balanceAmount,
  //   "demanded_amount": demandedAmount,
  //   "advance_amount": advanceAmount,
  //   "concession_amount": concessionAmount,
  //   "excempted_amount": excemptedAmount,
  //   "excemption_pending_amount": excemptionPendingAmount,
  //   "paid_amount": paidAmount,
  //   "penalty_collected": penaltyCollected,
  //   "penalty_demanded": penaltyDemanded,
  // };
}

class FeePaidDatum {
  FeePaidDatum({
    this.voucherNumber,
    this.transactionDate,
    this.paymentMode,
    this.paymentStatus,
    this.voucherTotalAmount,
    this.details,
  });

  String? voucherNumber;
  String? transactionDate;
  String? paymentMode;
  String? paymentStatus;
  String? voucherTotalAmount;
  List<FeePaidDatumDetail>? details;

  factory FeePaidDatum.fromJson(Map<String, dynamic> json) => FeePaidDatum(
    voucherNumber: json["voucher_number"],
    transactionDate: json["transaction_date"],
    paymentMode: json["payment_mode"],
    paymentStatus: json["payment_status"],
    voucherTotalAmount: json["voucher_total_amount"],
    details: List<FeePaidDatumDetail>.from(json["details"].map((x) => FeePaidDatumDetail.fromJson(x))),
  );

  // Map<String, dynamic> toJson() => {
  //   "voucher_number": voucherNumber,
  //   "transaction_date": transactionDate,
  //   "payment_mode": paymentMode,
  //   "payment_status": paymentStatus,
  //   "voucher_total_amount": voucherTotalAmount,
  //   "details": List<dynamic>.from(details.map((x) => x.toJson())),
  // };
}

class FeePaidDatumDetail {
  FeePaidDatumDetail({
    this.transactionDesc,
    this.transactionAmount,
  });

  String? transactionDesc;
  String? transactionAmount;

  factory FeePaidDatumDetail.fromJson(Map<String, dynamic> json) => FeePaidDatumDetail(
    transactionDesc: json["transaction_desc"],
    transactionAmount: json["transaction_amount"],
  );

  // Map<String, dynamic> toJson() => {
  //   "transaction_desc": transactionDesc,
  //   "transaction_amount": transactionAmount,
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
