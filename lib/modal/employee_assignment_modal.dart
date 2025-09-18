// To parse this JSON data, do
//
//     final employeeAssignments = employeeAssignmentsFromJson(jsonString);

import 'dart:convert';

EmployeeAssignments employeeAssignmentsFromJson(String str) =>
    EmployeeAssignments.fromJson(json.decode(str));

String employeeAssignmentsToJson(EmployeeAssignments data) =>
    json.encode(data.toJson());

class EmployeeAssignments {
  String message;
  List<Datum> data;
  bool success;

  EmployeeAssignments({
    required this.message,
    required this.data,
    required this.success,
  });

  factory EmployeeAssignments.fromJson(Map<String, dynamic> json) =>
      EmployeeAssignments(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "success": success,
  };
}

class Datum {
  String assignmentId;
  String assignmentName;
  String project;
  DateTime assignedDate;
  String status;
  String projectName;
  List<TaskAssignment> taskAssignments;
  List<dynamic> subTaskAssignments;
  int totalTasks;
  int assignedTasks;

  Datum({
    required this.assignmentId,
    required this.assignmentName,
    required this.project,
    required this.assignedDate,
    required this.status,
    required this.projectName,
    required this.taskAssignments,
    required this.subTaskAssignments,
    required this.totalTasks,
    required this.assignedTasks,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    assignmentId: json["assignment_id"],
    assignmentName: json["assignment_name"],
    project: json["project"],
    assignedDate: DateTime.parse(json["assigned_date"]),
    status: json["status"],
    projectName: json["project_name"],
    taskAssignments: List<TaskAssignment>.from(
      json["task_assignments"].map((x) => TaskAssignment.fromJson(x)),
    ),
    subTaskAssignments: List<dynamic>.from(
      json["sub_task_assignments"].map((x) => x),
    ),
    totalTasks: json["total_tasks"],
    assignedTasks: json["assigned_tasks"],
  );

  Map<String, dynamic> toJson() => {
    "assignment_id": assignmentId,
    "assignment_name": assignmentName,
    "project": project,
    "assigned_date":
        "${assignedDate.year.toString().padLeft(4, '0')}-${assignedDate.month.toString().padLeft(2, '0')}-${assignedDate.day.toString().padLeft(2, '0')}",
    "status": status,
    "project_name": projectName,
    "task_assignments": List<dynamic>.from(
      taskAssignments.map((x) => x.toJson()),
    ),
    "sub_task_assignments": List<dynamic>.from(
      subTaskAssignments.map((x) => x),
    ),
    "total_tasks": totalTasks,
    "assigned_tasks": assignedTasks,
  };
}

class TaskAssignment {
  String task;
  String taskSubject;
  dynamic employee;
  dynamic employeeName;
  String assignmentStatus;
  double workloadPercentage;

  TaskAssignment({
    required this.task,
    required this.taskSubject,
    required this.employee,
    required this.employeeName,
    required this.assignmentStatus,
    required this.workloadPercentage,
  });

  factory TaskAssignment.fromJson(Map<String, dynamic> json) => TaskAssignment(
    task: json["task"],
    taskSubject: json["task_subject"],
    employee: json["employee"],
    employeeName: json["employee_name"],
    assignmentStatus: json["assignment_status"],
    workloadPercentage: json["workload_percentage"],
  );

  Map<String, dynamic> toJson() => {
    "task": task,
    "task_subject": taskSubject,
    "employee": employee,
    "employee_name": employeeName,
    "assignment_status": assignmentStatus,
    "workload_percentage": workloadPercentage,
  };
}
