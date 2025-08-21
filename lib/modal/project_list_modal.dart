// To parse this JSON data, do:
//
//     final projectList = projectListFromJson(jsonString);

import 'dart:convert';

ProjectList projectListFromJson(String str) =>
    ProjectList.fromJson(json.decode(str));

String projectListToJson(ProjectList data) => json.encode(data.toJson());

class ProjectList {
  String? message;
  List<ProjectDetails>? data;
  bool? success;

  ProjectList({this.message, this.data, this.success});

  factory ProjectList.fromJson(Map<String, dynamic> json) => ProjectList(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<ProjectDetails>.from(
            json["data"].map((x) => ProjectDetails.fromJson(x)),
          ),
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

class ProjectDetails {
  String? name;
  String? projectName;
  String? projectType;
  String? priority;
  DateTime? expectedStartDate;
  DateTime? expectedEndDate;
  String? isActive;
  String? notes;

  ProjectDetails({
    this.name,
    this.projectName,
    this.projectType,
    this.priority,
    this.expectedStartDate,
    this.expectedEndDate,
    this.isActive,
    this.notes,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) => ProjectDetails(
    name: json["name"],
    projectName: json["project_name"],
    projectType: json["project_type"],
    priority: json["priority"],
    expectedStartDate: json["expected_start_date"] != null
        ? DateTime.tryParse(json["expected_start_date"])
        : null,
    expectedEndDate: json["expected_end_date"] != null
        ? DateTime.tryParse(json["expected_end_date"])
        : null,
    isActive: json["is_active"],
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "project_name": projectName,
    "project_type": projectType,
    "priority": priority,
    "expected_start_date": expectedStartDate != null
        ? "${expectedStartDate!.year.toString().padLeft(4, '0')}-${expectedStartDate!.month.toString().padLeft(2, '0')}-${expectedStartDate!.day.toString().padLeft(2, '0')}"
        : null,
    "expected_end_date": expectedEndDate != null
        ? "${expectedEndDate!.year.toString().padLeft(4, '0')}-${expectedEndDate!.month.toString().padLeft(2, '0')}-${expectedEndDate!.day.toString().padLeft(2, '0')}"
        : null,
    "is_active": isActive,
    "notes": notes,
  };
}
