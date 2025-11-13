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
  bool? success;

  AllTaskListModal({required this.message, required this.data, this.success});

  factory AllTaskListModal.fromJson(Map<String, dynamic> json) {
    // Extract the nested "message" object
    final messageObj = json["message"] as Map<String, dynamic>;

    return AllTaskListModal(
      message: messageObj["message"] as String,
      data: List<TaskDetails>.from(
        messageObj["data"].map((x) => TaskDetails.fromJson(x)),
      ),
      success: messageObj["success"] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    "message": {
      "success": success,
      "message": message,
      "data": List<dynamic>.from(data.map((x) => x.toJson())),
    },
  };
}

class TaskDetails {
  String name;
  String? subject;
  String status;
  String priority;
  double progress;
  String? project;
  String? projectName;
  DateTime? expStartDate;
  DateTime? expEndDate;
  String? description;
  DateTime creation;
  String? assignedUsers;
  String? type;
  double? customEstimatedHours;
  String? parentTask;
  double? expectedTime;

  TaskDetails({
    required this.name,
    this.subject,
    required this.status,
    required this.priority,
    required this.progress,
    this.project,
    this.projectName,
    this.expStartDate,
    this.expEndDate,
    this.description,
    required this.creation,
    this.assignedUsers,
    this.type,
    this.customEstimatedHours,
    this.parentTask,
    this.expectedTime,
  });

  factory TaskDetails.fromJson(Map<String, dynamic> json) => TaskDetails(
    name: json["name"],
    subject: json["subject"],
    status: json["status"],
    priority: json["priority"],
    progress: (json["progress"] as num).toDouble(),
    project: json["project"],
    projectName: json["custom_project_name"],
    expStartDate: json["exp_start_date"] != null
        ? DateTime.parse(json["exp_start_date"])
        : null,
    expEndDate: json["exp_end_date"] != null
        ? DateTime.parse(json["exp_end_date"])
        : null,
    description: json["description"],
    creation: DateTime.parse(json["creation"]),
    assignedUsers: json["custom_assigned_employee"],
    type: json["type"],
    customEstimatedHours: (json["custom_estimated_hours"] as num?)?.toDouble(),
    parentTask: json["parent_task"],
    expectedTime: (json["expected_time"] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "subject": subject,
    "status": status,
    "priority": priority,
    "progress": progress,
    "project": project,
    "custom_project_name": projectName,
    "exp_start_date": expStartDate?.toIso8601String().split('T').first,
    "exp_end_date": expEndDate?.toIso8601String().split('T').first,
    "description": description,
    "creation": creation.toIso8601String(),
    "custom_assigned_employee": assignedUsers,
    "type": type,
    "custom_estimated_hours": customEstimatedHours,
    "parent_task": parentTask,
    "expected_time": expectedTime,
  };
}
