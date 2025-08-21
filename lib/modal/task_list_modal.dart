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
  bool success;

  AllTaskListModal({
    required this.message,
    required this.data,
    required this.success,
  });

  factory AllTaskListModal.fromJson(Map<String, dynamic> json) =>
      AllTaskListModal(
        message: json["message"],
        data: List<TaskDetails>.from(
          json["data"].map((x) => TaskDetails.fromJson(x)),
        ),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
  };
}

class TaskDetails {
  String name;
  String subject;
  String status;
  String priority;
  double progress;
  String project;
  DateTime expStartDate;
  DateTime expEndDate;
  String description;
  DateTime creation;
  List<String> assignedUsers;

  TaskDetails({
    required this.name,
    required this.subject,
    required this.status,
    required this.priority,
    required this.progress,
    required this.project,
    required this.expStartDate,
    required this.expEndDate,
    required this.description,
    required this.creation,
    required this.assignedUsers,
  });

  factory TaskDetails.fromJson(Map<String, dynamic> json) => TaskDetails(
    name: json["name"],
    subject: json["subject"],
    status: json["status"],
    priority: json["priority"],
    progress: json["progress"],
    project: json["project"],
    expStartDate: DateTime.parse(json["exp_start_date"]),
    expEndDate: DateTime.parse(json["exp_end_date"]),
    description: json["description"],
    creation: DateTime.parse(json["creation"]),
    assignedUsers: List<String>.from(json["assigned_users"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "subject": subject,
    "status": status,
    "priority": priority,
    "progress": progress,
    "project": project,
    "exp_start_date":
        "${expStartDate.year.toString().padLeft(4, '0')}-${expStartDate.month.toString().padLeft(2, '0')}-${expStartDate.day.toString().padLeft(2, '0')}",
    "exp_end_date":
        "${expEndDate.year.toString().padLeft(4, '0')}-${expEndDate.month.toString().padLeft(2, '0')}-${expEndDate.day.toString().padLeft(2, '0')}",
    "description": description,
    "creation": creation.toIso8601String(),
    "assigned_users": List<dynamic>.from(assignedUsers.map((x) => x)),
  };
}
