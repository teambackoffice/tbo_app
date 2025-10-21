// To parse this JSON data, do
//
//     final employeeDateRequestModal = employeeDateRequestModalFromJson(jsonString);

import 'dart:convert';

EmployeeDateRequestModal employeeDateRequestModalFromJson(String str) =>
    EmployeeDateRequestModal.fromJson(json.decode(str));

String employeeDateRequestModalToJson(EmployeeDateRequestModal data) =>
    json.encode(data.toJson());

class EmployeeDateRequestModal {
  String message;
  List<Datum> data;
  bool success;

  EmployeeDateRequestModal({
    required this.message,
    required this.data,
    required this.success,
  });

  factory EmployeeDateRequestModal.fromJson(Map<String, dynamic> json) =>
      EmployeeDateRequestModal(
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
  String employee;
  String employeeName;
  DateTime requestDate;
  Status status;
  String task;
  String? taskSubject;
  DateTime requestedStartDate;
  DateTime requestedEndDate;
  String reason;

  Datum({
    required this.name,
    required this.employee,
    required this.employeeName,
    required this.requestDate,
    required this.status,
    required this.task,
    this.taskSubject,
    required this.requestedStartDate,
    required this.requestedEndDate,
    required this.reason,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    employee: json["employee"],
    employeeName: json["employee_name"],
    requestDate: DateTime.parse(json["request_date"]),
    status: statusValues.map[json["status"]] ?? Status.PENDING,
    task: json["task"],
    taskSubject: json["task_subject"],
    requestedStartDate: DateTime.parse(json["requested_start_date"]),
    requestedEndDate: DateTime.parse(json["requested_end_date"]),
    reason: json["reason"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "employee": employee,
    "employee_name": employeeName,
    "request_date":
        "${requestDate.year.toString().padLeft(4, '0')}-${requestDate.month.toString().padLeft(2, '0')}-${requestDate.day.toString().padLeft(2, '0')}",
    "status": statusValues.reverse[status],
    "task": task,
    "task_subject": taskSubject,
    "requested_start_date":
        "${requestedStartDate.year.toString().padLeft(4, '0')}-${requestedStartDate.month.toString().padLeft(2, '0')}-${requestedStartDate.day.toString().padLeft(2, '0')}",
    "requested_end_date":
        "${requestedEndDate.year.toString().padLeft(4, '0')}-${requestedEndDate.month.toString().padLeft(2, '0')}-${requestedEndDate.day.toString().padLeft(2, '0')}",
    "reason": reason,
  };
}

enum Status { APPROVED, PENDING }

final statusValues = EnumValues({
  "Approved": Status.APPROVED,
  "Pending": Status.PENDING,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
