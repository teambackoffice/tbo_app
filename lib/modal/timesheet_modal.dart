// To parse this JSON data, do
//
//     final timesheetModal = timesheetModalFromJson(jsonString);

import 'dart:convert';

TimesheetModal timesheetModalFromJson(String str) =>
    TimesheetModal.fromJson(json.decode(str));

String timesheetModalToJson(TimesheetModal data) => json.encode(data.toJson());

class TimesheetModal {
  String message;
  List<Datum> data;

  TimesheetModal({required this.message, required this.data});

  factory TimesheetModal.fromJson(Map<String, dynamic> json) {
    return TimesheetModal(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

class Datum {
  String name;
  String? employee; // Made nullable
  String? employeeName; // Made nullable
  String status;
  int docstatus;
  double totalHours;
  DateTime startDate;
  DateTime endDate;
  List<TimeLog> timeLogs;
  String docstatusName;

  Datum({
    required this.name,
    this.employee, // Removed required
    this.employeeName, // Removed required
    required this.status,
    required this.docstatus,
    required this.totalHours,
    required this.startDate,
    required this.endDate,
    required this.timeLogs,
    required this.docstatusName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"]?.toString() ?? '',
    employee: json["employee"]?.toString(), // Can be null
    employeeName: json["employee_name"]?.toString(), // Can be null
    status: json["status"]?.toString() ?? '',
    docstatus: json["docstatus"] ?? 0,
    docstatusName: json["docstatus_name"]?.toString() ?? '',
    totalHours: (json["total_hours"] as num?)?.toDouble() ?? 0.0,
    startDate:
        json["start_date"] != null && json["start_date"].toString().isNotEmpty
        ? DateTime.parse(json["start_date"])
        : DateTime.now(),
    endDate: json["end_date"] != null && json["end_date"].toString().isNotEmpty
        ? DateTime.parse(json["end_date"])
        : DateTime.now(),
    timeLogs: List<TimeLog>.from(
      (json["time_logs"] as List<dynamic>).map((x) => TimeLog.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "employee": employee,
    "employee_name": employeeName,
    "status": status,
    "docstatus": docstatus,
    "docstatus_name": docstatusName,
    "total_hours": totalHours,
    "start_date":
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date":
        "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "time_logs": List<dynamic>.from(timeLogs.map((x) => x.toJson())),
  };
}

class TimeLog {
  String? activityType; // Made nullable
  DateTime fromTime;
  DateTime? toTime; // Made nullable
  double hours;
  String? project;
  String? task;
  String? description;
  String? projectName;

  TimeLog({
    this.activityType, // Removed required
    required this.fromTime,
    this.toTime, // Removed required
    required this.hours,
    this.project,
    this.task,
    this.description,
    this.projectName,
  });

  factory TimeLog.fromJson(Map<String, dynamic> json) => TimeLog(
    activityType: json["activity_type"], // Can be null
    fromTime:
        json["from_time"] != null && json["from_time"].toString().isNotEmpty
        ? DateTime.parse(json["from_time"])
        : DateTime.now(), // Fallback to current time if null/empty
    toTime: json["to_time"] != null && json["to_time"].toString().isNotEmpty
        ? DateTime.parse(json["to_time"])
        : null, // Can be null
    hours: (json["hours"] as num?)?.toDouble() ?? 0.0,
    project: json["project"]?.toString(),
    task: json["task"]?.toString(),
    description: json["description"]?.toString(),
    projectName: json["project_name"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "activity_type": activityType,
    "from_time": fromTime.toIso8601String(),
    "to_time": toTime?.toIso8601String(),
    "hours": hours,
    "project": project,
    "task": task,
    "description": description,
    "project_name": projectName,
  };
}
