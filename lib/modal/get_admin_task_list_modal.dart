// To parse this JSON data, do
//
//     final getAdminTaskListModalClass = getAdminTaskListModalClassFromJson(jsonString);

import 'dart:convert';

GetAdminTaskListModalClass getAdminTaskListModalClassFromJson(String str) =>
    GetAdminTaskListModalClass.fromJson(json.decode(str));

String getAdminTaskListModalClassToJson(GetAdminTaskListModalClass data) =>
    json.encode(data.toJson());

class GetAdminTaskListModalClass {
  String message;
  Data data;
  bool success;

  GetAdminTaskListModalClass({
    required this.message,
    required this.data,
    required this.success,
  });

  factory GetAdminTaskListModalClass.fromJson(Map<String, dynamic> json) =>
      GetAdminTaskListModalClass(
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
  String projectId;
  String projectName;
  String projectType;
  String priority;
  DateTime expectedStartDate;
  DateTime expectedEndDate;
  String isActive;
  dynamic notes;
  String status;
  List<Task> tasks;

  Data({
    required this.projectId,
    required this.projectName,
    required this.projectType,
    required this.priority,
    required this.expectedStartDate,
    required this.expectedEndDate,
    required this.isActive,
    required this.notes,
    required this.status,
    required this.tasks,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    projectId: json["project_id"],
    projectName: json["project_name"],
    projectType: json["project_type"],
    priority: json["priority"],
    expectedStartDate: DateTime.parse(json["expected_start_date"]),
    expectedEndDate: DateTime.parse(json["expected_end_date"]),
    isActive: json["is_active"],
    notes: json["notes"],
    status: json["status"],
    tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "project_id": projectId,
    "project_name": projectName,
    "project_type": projectType,
    "priority": priority,
    "expected_start_date":
        "${expectedStartDate.year.toString().padLeft(4, '0')}-${expectedStartDate.month.toString().padLeft(2, '0')}-${expectedStartDate.day.toString().padLeft(2, '0')}",
    "expected_end_date":
        "${expectedEndDate.year.toString().padLeft(4, '0')}-${expectedEndDate.month.toString().padLeft(2, '0')}-${expectedEndDate.day.toString().padLeft(2, '0')}",
    "is_active": isActive,
    "notes": notes,
    "status": status,
    "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
  };
}

class Task {
  String taskId;
  String subject;
  String status;
  String priority;
  dynamic employeeId;
  String employeeName;
  String description;
  dynamic expectedStartDate;
  dynamic expectedEndDate;

  Task({
    required this.taskId,
    required this.subject,
    required this.status,
    required this.priority,
    required this.employeeId,
    required this.employeeName,
    required this.description,
    required this.expectedStartDate,
    required this.expectedEndDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    taskId: json["task_id"],
    subject: json["subject"],
    status: json["status"],
    priority: json["priority"],
    employeeId: json["employee_id"],
    employeeName: json["employee_name"],
    description: json["description"],
    expectedStartDate: json["expected_start_date"],
    expectedEndDate: json["expected_end_date"],
  );

  Map<String, dynamic> toJson() => {
    "task_id": taskId,
    "subject": subject,
    "status": status,
    "priority": priority,
    "employee_id": employeeId,
    "employee_name": employeeName,
    "description": description,
    "expected_start_date": expectedStartDate,
    "expected_end_date": expectedEndDate,
  };
}
