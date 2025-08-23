// To parse this JSON data, do
//
//     final allLeadsModal = allLeadsModalFromJson(jsonString);

import 'dart:convert';

AllLeadsModal allLeadsModalFromJson(String str) =>
    AllLeadsModal.fromJson(json.decode(str));

String allLeadsModalToJson(AllLeadsModal? data) => json.encode(data?.toJson());

class AllLeadsModal {
  String? message;
  List<Datum>? data;
  bool? success;

  AllLeadsModal({this.message, this.data, this.success});

  factory AllLeadsModal.fromJson(Map<String, dynamic> json) => AllLeadsModal(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
  };
}

class Datum {
  String? leadId;
  String? leadName;
  String? companyName;
  String? emailId;
  String? mobileNo;
  String? status;
  String? source;
  dynamic campaignName;
  String? leadOwner;
  String? territory;

  Datum({
    this.leadId,
    this.leadName,
    this.companyName,
    this.emailId,
    this.mobileNo,
    this.status,
    this.source,
    this.campaignName,
    this.leadOwner,
    this.territory,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    leadId: json["lead_id"],
    leadName: json["lead_name"],
    companyName: json["company_name"],
    emailId: json["email_id"],
    mobileNo: json["mobile_no"],
    status: json["status"],
    source: json["source"],
    campaignName: json["campaign_name"],
    leadOwner: json["lead_owner"],
    territory: json["territory"],
  );

  Map<String, dynamic> toJson() => {
    "lead_id": leadId,
    "lead_name": leadName,
    "company_name": companyName,
    "email_id": emailId,
    "mobile_no": mobileNo,
    "status": status,
    "source": source,
    "campaign_name": campaignName,
    "lead_owner": leadOwner,
    "territory": territory,
  };
}
