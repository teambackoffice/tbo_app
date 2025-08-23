// To parse this JSON data, do
//
//     final allLeadsDetailsModal = allLeadsDetailsModalFromJson(jsonString);

import 'dart:convert';

AllLeadsDetailsModal allLeadsDetailsModalFromJson(String str) =>
    AllLeadsDetailsModal.fromJson(json.decode(str));

String allLeadsDetailsModalToJson(AllLeadsDetailsModal data) =>
    json.encode(data.toJson());

class AllLeadsDetailsModal {
  String message;
  Data data;
  bool success;

  AllLeadsDetailsModal({
    required this.message,
    required this.data,
    required this.success,
  });

  factory AllLeadsDetailsModal.fromJson(Map<String, dynamic> json) =>
      AllLeadsDetailsModal(
        message: json["message"],
        data: Data.fromJson(json["data"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
    "success": success,
  };
}

class Data {
  String leadId;
  String leadName;
  String companyName;
  String emailId;
  String mobileNo;
  String status;
  String source;
  String campaignName;
  String leadOwner;
  String territory;
  String website;
  String marketSegment;
  String gender;
  String city;
  String state;
  String country;
  String phone;
  String fax;
  double annualRevenue;
  String noOfEmployees;
  String industry;
  DateTime creation;
  DateTime modified;

  Data({
    required this.leadId,
    required this.leadName,
    required this.companyName,
    required this.emailId,
    required this.mobileNo,
    required this.status,
    required this.source,
    required this.campaignName,
    required this.leadOwner,
    required this.territory,
    required this.website,
    required this.marketSegment,
    required this.gender,
    required this.city,
    required this.state,
    required this.country,
    required this.phone,
    required this.fax,
    required this.annualRevenue,
    required this.noOfEmployees,
    required this.industry,
    required this.creation,
    required this.modified,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    website: json["website"],
    marketSegment: json["market_segment"],
    gender: json["gender"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    phone: json["phone"],
    fax: json["fax"],
    annualRevenue: json["annual_revenue"],
    noOfEmployees: json["no_of_employees"],
    industry: json["industry"],
    creation: DateTime.parse(json["creation"]),
    modified: DateTime.parse(json["modified"]),
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
    "website": website,
    "market_segment": marketSegment,
    "gender": gender,
    "city": city,
    "state": state,
    "country": country,
    "phone": phone,
    "fax": fax,
    "annual_revenue": annualRevenue,
    "no_of_employees": noOfEmployees,
    "industry": industry,
    "creation": creation.toIso8601String(),
    "modified": modified.toIso8601String(),
  };
}
