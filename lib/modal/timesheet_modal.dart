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
    // The 'message' key itself contains the real data
    final inner = json['message'];
    return TimesheetModal(
      message: inner['message'] ?? '',
      data: (inner['data'] as List<dynamic>)
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
  String employee;
  String employeeName;
  String status;
  int docstatus;
  double totalHours;
  DateTime startDate;
  DateTime endDate;
  List<TimeLog> timeLogs;
  String docstatusName;

  Datum({
    required this.name,
    required this.employee,
    required this.employeeName,
    required this.status,
    required this.docstatus,
    required this.totalHours,
    required this.startDate,
    required this.endDate,
    required this.timeLogs,
    required this.docstatusName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    employee: json["employee"],
    employeeName: json["employee_name"],
    status: json["status"],
    docstatus: json["docstatus"],
    docstatusName: json["docstatus_name"],
    totalHours: json["total_hours"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    timeLogs: List<TimeLog>.from(
      json["time_logs"].map((x) => TimeLog.fromJson(x)),
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
  String activityType;
  DateTime fromTime;
  DateTime toTime;
  double hours;
  String? project; // nullable
  String? task; // nullable
  String? description; // nullable

  TimeLog({
    required this.activityType,
    required this.fromTime,
    required this.toTime,
    required this.hours,
    this.project,
    this.task,
    this.description,
  });

  factory TimeLog.fromJson(Map<String, dynamic> json) => TimeLog(
    activityType: json["activity_type"],
    fromTime: DateTime.parse(json["from_time"]),
    toTime: DateTime.parse(json["to_time"]),
    hours: (json["hours"] as num).toDouble(),
    project: json["project"], // safe: nullable
    task: json["task"], // safe: nullable
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "activity_type": activityType,
    "from_time": fromTime.toIso8601String(),
    "to_time": toTime.toIso8601String(),
    "hours": hours,
    "project": project,
    "task": task,
    "description": description,
  };
}
