// To parse this JSON data, do
//
//     final employeeHandOverModal = employeeHandOverModalFromJson(jsonString);

import 'dart:convert';

EmployeeHandOverModal employeeHandOverModalFromJson(String str) =>
    EmployeeHandOverModal.fromJson(json.decode(str));

String employeeHandOverModalToJson(EmployeeHandOverModal data) =>
    json.encode(data.toJson());

class EmployeeHandOverModal {
  String message;
  List<Datum> data;
  bool success;

  EmployeeHandOverModal({
    required this.message,
    required this.data,
    required this.success,
  });

  factory EmployeeHandOverModal.fromJson(Map<String, dynamic> json) =>
      EmployeeHandOverModal(
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
  String name;
  String fromEmployee;
  String fromEmployeeName;
  String toEmployee;
  String toEmployeeName;
  DateTime requestDate;
  String status;
  dynamic taskAssignment;
  String task;
  String? taskSubject;
  String handoverReason;
  String handoverType;
  String handoverNotes;
  int isPermanentHandover;

  Datum({
    required this.name,
    required this.fromEmployee,
    required this.fromEmployeeName,
    required this.toEmployee,
    required this.toEmployeeName,
    required this.requestDate,
    required this.status,
    required this.taskAssignment,
    required this.task,
    required this.taskSubject,
    required this.handoverReason,
    required this.handoverType,
    required this.handoverNotes,
    required this.isPermanentHandover,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    fromEmployee: json["from_employee"],
    fromEmployeeName: json["from_employee_name"],
    toEmployee: json["to_employee"],
    toEmployeeName: json["to_employee_name"],
    requestDate: DateTime.parse(json["request_date"]),
    status: json["status"],
    taskAssignment: json["task_assignment"],
    task: json["task"],
    taskSubject: json["task_subject"],
    handoverReason: json["handover_reason"],
    handoverType: json["handover_type"],
    handoverNotes: json["handover_notes"],
    isPermanentHandover: json["is_permanent_handover"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "from_employee": fromEmployee,
    "from_employee_name": fromEmployeeName,
    "to_employee": toEmployee,
    "to_employee_name": toEmployeeName,
    "request_date":
        "${requestDate.year.toString().padLeft(4, '0')}-${requestDate.month.toString().padLeft(2, '0')}-${requestDate.day.toString().padLeft(2, '0')}",
    "status": status,
    "task_assignment": taskAssignment,
    "task": task,
    "task_subject": taskSubject,
    "handover_reason": handoverReason,
    "handover_type": handoverType,
    "handover_notes": handoverNotes,
    "is_permanent_handover": isPermanentHandover,
  };
}
