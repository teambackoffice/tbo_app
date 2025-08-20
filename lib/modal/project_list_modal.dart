// To parse this JSON data, do
//
//     final projectList = projectListFromJson(jsonString);

import 'dart:convert';

ProjectList projectListFromJson(String str) =>
    ProjectList.fromJson(json.decode(str));

String projectListToJson(ProjectList data) => json.encode(data.toJson());

class ProjectList {
  String message;
  List<ProjectDetails> data;
  bool success;

  ProjectList({
    required this.message,
    required this.data,
    required this.success,
  });

  factory ProjectList.fromJson(Map<String, dynamic> json) => ProjectList(
    message: json["message"],
    data: List<ProjectDetails>.from(
      json["data"].map((x) => ProjectDetails.fromJson(x)),
    ),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
  };
}

class ProjectDetails {
  String name;
  String projectName;
  String projectType;
  String priority;
  DateTime expectedStartDate;
  DateTime expectedEndDate;
  String isActive;
  String notes;

  ProjectDetails({
    required this.name,
    required this.projectName,
    required this.projectType,
    required this.priority,
    required this.expectedStartDate,
    required this.expectedEndDate,
    required this.isActive,
    required this.notes,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) => ProjectDetails(
    name: json["name"],
    projectName: json["project_name"],
    projectType: json["project_type"],
    priority: json["priority"],
    expectedStartDate: DateTime.parse(json["expected_start_date"]),
    expectedEndDate: DateTime.parse(json["expected_end_date"]),
    isActive: json["is_active"],
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "project_name": projectName,
    "project_type": projectType,
    "priority": priority,
    "expected_start_date":
        "${expectedStartDate.year.toString().padLeft(4, '0')}-${expectedStartDate.month.toString().padLeft(2, '0')}-${expectedStartDate.day.toString().padLeft(2, '0')}",
    "expected_end_date":
        "${expectedEndDate.year.toString().padLeft(4, '0')}-${expectedEndDate.month.toString().padLeft(2, '0')}-${expectedEndDate.day.toString().padLeft(2, '0')}",
    "is_active": isActive,
    "notes": notes,
  };
}
