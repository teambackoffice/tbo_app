import 'dart:convert';

TaskListResponse taskListResponseFromJson(String str) =>
    TaskListResponse.fromJson(json.decode(str));

String taskListResponseToJson(TaskListResponse data) =>
    json.encode(data.toJson());

class TaskListResponse {
  final int successKey;
  final String message;
  final List<Task> data;

  TaskListResponse({
    required this.successKey,
    required this.message,
    required this.data,
  });

  factory TaskListResponse.fromJson(Map<String, dynamic> json) =>
      TaskListResponse(
        successKey: json["success_key"],
        message: json["message"],
        data: List<Task>.from(json["data"].map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success_key": successKey,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Task {
  final String name;
  final String subject;
  final String status;
  final String priority;
  final double? progress;
  final String project;
  final String? expStartDate;
  final String? expEndDate;
  final String customAssignedEmployee;
  final String? description;
  final String creation;
  final String? parentTask;
  final String projectName;

  Task({
    required this.name,
    required this.subject,
    required this.status,
    required this.priority,
    required this.progress,
    required this.project,
    this.expStartDate,
    this.expEndDate,
    required this.customAssignedEmployee,
    this.description,
    required this.creation,
    this.parentTask,
    required this.projectName,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    name: json["name"],
    subject: json["subject"],
    status: json["status"],
    priority: json["priority"],
    progress: (json["progress"] as num).toDouble(),
    project: json["project"],
    expStartDate: json["exp_start_date"],
    expEndDate: json["exp_end_date"],
    customAssignedEmployee: json["custom_assigned_employee"],
    description: json["description"],
    creation: json["creation"],
    parentTask: json["parent_task"],
    projectName: json["project_name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "subject": subject,
    "status": status,
    "priority": priority,
    "progress": progress,
    "project": project,
    "exp_start_date": expStartDate,
    "exp_end_date": expEndDate,
    "custom_assigned_employee": customAssignedEmployee,
    "description": description,
    "creation": creation,
    "parent_task": parentTask,
    "project_name": projectName,
  };
}
