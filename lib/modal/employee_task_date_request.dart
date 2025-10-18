// To parse this JSON data, do
//
//     final employeeDateRequestModalClass = employeeDateRequestModalClassFromJson(jsonString);

import 'dart:convert';

EmployeeDateRequestModalClass employeeDateRequestModalClassFromJson(
  String str,
) => EmployeeDateRequestModalClass.fromJson(json.decode(str));

String employeeDateRequestModalClassToJson(
  EmployeeDateRequestModalClass data,
) => json.encode(data.toJson());

class EmployeeDateRequestModalClass {
  Message message;

  EmployeeDateRequestModalClass({required this.message});

  factory EmployeeDateRequestModalClass.fromJson(Map<String, dynamic> json) =>
      EmployeeDateRequestModalClass(message: Message.fromJson(json["message"]));

  Map<String, dynamic> toJson() => {"message": message.toJson()};
}

class Message {
  bool success;
  List<DateRequestData> data;
  String message;

  Message({required this.success, required this.data, required this.message});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    success: json["success"],
    data: List<DateRequestData>.from(
      json["data"].map((x) => DateRequestData.fromJson(x)),
    ),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class DateRequestData {
  String name;
  String? taskAssignment;
  String? task;
  String? taskSubject;
  String? currentStartDate;
  String? currentEndDate;
  String? requestedStartDate;
  String? requestedEndDate;
  String? reason;
  String? status;
  String? requestDate;
  String? approvedBy;
  String? approvalDate;
  String? approvalNotes;
  String? assignmentName;
  String? project;
  String? projectName;

  DateRequestData({
    required this.name,
    this.taskAssignment,
    this.task,
    this.taskSubject,
    this.currentStartDate,
    this.currentEndDate,
    this.requestedStartDate,
    this.requestedEndDate,
    this.reason,
    this.status,
    this.requestDate,
    this.approvedBy,
    this.approvalDate,
    this.approvalNotes,
    this.assignmentName,
    this.project,
    this.projectName,
  });

  factory DateRequestData.fromJson(Map<String, dynamic> json) =>
      DateRequestData(
        name: json["name"] ?? '',
        taskAssignment: json["task_assignment"],
        task: json["task"],
        taskSubject: json["task_subject"],
        currentStartDate: json["current_start_date"],
        currentEndDate: json["current_end_date"],
        requestedStartDate: json["requested_start_date"],
        requestedEndDate: json["requested_end_date"],
        reason: json["reason"],
        status: json["status"],
        requestDate: json["request_date"],
        approvedBy: json["approved_by"],
        approvalDate: json["approval_date"],
        approvalNotes: json["approval_notes"],
        assignmentName: json["assignment_name"],
        project: json["project"],
        projectName: json["project_name"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "task_assignment": taskAssignment,
    "task": task,
    "task_subject": taskSubject,
    "current_start_date": currentStartDate,
    "current_end_date": currentEndDate,
    "requested_start_date": requestedStartDate,
    "requested_end_date": requestedEndDate,
    "reason": reason,
    "status": status,
    "request_date": requestDate,
    "approved_by": approvedBy,
    "approval_date": approvalDate,
    "approval_notes": approvalNotes,
    "assignment_name": assignmentName,
    "project": project,
    "project_name": projectName,
  };
}
