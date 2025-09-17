// To parse this JSON data, do
//
//     final leadSegmentModal = leadSegmentModalFromJson(jsonString);

import 'dart:convert';

LeadSegmentModal leadSegmentModalFromJson(String str) =>
    LeadSegmentModal.fromJson(json.decode(str));

String leadSegmentModalToJson(LeadSegmentModal data) =>
    json.encode(data.toJson());

class LeadSegmentModal {
  String message;
  List<LeadSegments> data;
  bool success;

  LeadSegmentModal({
    required this.message,
    required this.data,
    required this.success,
  });

  factory LeadSegmentModal.fromJson(Map<String, dynamic> json) =>
      LeadSegmentModal(
        message: json["message"],
        data: List<LeadSegments>.from(
          json["data"].map((x) => LeadSegments.fromJson(x)),
        ),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
  };
}

class LeadSegments {
  String name;
  String leadSegment;
  dynamic description;
  int isActive;
  double totalEstimatedCost;

  LeadSegments({
    required this.name,
    required this.leadSegment,
    required this.description,
    required this.isActive,
    required this.totalEstimatedCost,
  });

  factory LeadSegments.fromJson(Map<String, dynamic> json) => LeadSegments(
    name: json["name"],
    leadSegment: json["lead_segment"],
    description: json["description"],
    isActive: json["is_active"],
    totalEstimatedCost: (json["total_estimated_cost"] as num)
        .toDouble(), // ✅ cast to double
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "lead_segment": leadSegment,
    "description": description,
    "is_active": isActive,
    "total_estimated_cost": totalEstimatedCost,
  };
}
