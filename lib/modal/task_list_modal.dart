// To parse this JSON data, do
//
//     final allTaskListModal = allTaskListModalFromJson(jsonString);

import 'dart:convert';

AllTaskListModal allTaskListModalFromJson(String str) =>
    AllTaskListModal.fromJson(json.decode(str));

String allTaskListModalToJson(AllTaskListModal data) =>
    json.encode(data.toJson());

class AllTaskListModal {
  String message;
  List<TaskDetails> data;
  bool? success; // Made nullable since it might not be in response

  AllTaskListModal({required this.message, required this.data, this.success});

  factory AllTaskListModal.fromJson(Map<String, dynamic> json) =>
      AllTaskListModal(
        message: json["message"],
        data: List<TaskDetails>.from(
          json["data"].map((x) => TaskDetails.fromJson(x)),
        ),
        success: json["success"], // Will be null if not present
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
  };
}

class TaskDetails {
  String name;
  String? subject; // Made nullable
  String status;
  String priority;
  double progress;
  String? project; // Made nullable
  DateTime? expStartDate; // Made nullable - this was causing the main error
  DateTime? expEndDate; // Made nullable - this was causing the main error
  String? description; // Made nullable
  DateTime creation;
  List<String> assignedUsers;

  TaskDetails({
    required this.name,
    this.subject,
    required this.status,
    required this.priority,
    required this.progress,
    this.project,
    this.expStartDate,
    this.expEndDate,
    this.description,
    required this.creation,
    required this.assignedUsers,
  });

  factory TaskDetails.fromJson(Map<String, dynamic> json) => TaskDetails(
    name: json["name"],
    subject: json["subject"], // Can be null
    status: json["status"],
    priority: json["priority"],
    progress: (json["progress"] as num).toDouble(),
    project: json["project"], // Can be null
    expStartDate: json["exp_start_date"] != null
        ? DateTime.parse(json["exp_start_date"])
        : null, // Handle null dates
    expEndDate: json["exp_end_date"] != null
        ? DateTime.parse(json["exp_end_date"])
        : null, // Handle null dates
    description: json["description"], // Can be null
    creation: DateTime.parse(json["creation"]),
    assignedUsers: json["assigned_users"] != null
        ? List<String>.from(json["assigned_users"].map((x) => x))
        : [], // Handle null assigned_users
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "subject": subject,
    "status": status,
    "priority": priority,
    "progress": progress,
    "project": project,
    "exp_start_date": expStartDate != null
        ? "${expStartDate!.year.toString().padLeft(4, '0')}-${expStartDate!.month.toString().padLeft(2, '0')}-${expStartDate!.day.toString().padLeft(2, '0')}"
        : null,
    "exp_end_date": expEndDate != null
        ? "${expEndDate!.year.toString().padLeft(4, '0')}-${expEndDate!.month.toString().padLeft(2, '0')}-${expEndDate!.day.toString().padLeft(2, '0')}"
        : null,
    "description": description,
    "creation": creation.toIso8601String(),
    "assigned_users": List<dynamic>.from(assignedUsers.map((x) => x)),
  };
}
