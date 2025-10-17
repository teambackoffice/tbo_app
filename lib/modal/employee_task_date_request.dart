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
  List<Map<String, String?>> data;
  String message;

  Message({required this.success, required this.data, required this.message});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    success: json["success"],
    data: List<Map<String, String?>>.from(
      json["data"].map(
        (x) => Map.from(x).map((k, v) => MapEntry<String, String?>(k, v)),
      ),
    ),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(
      data.map(
        (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)),
      ),
    ),
    "message": message,
  };
}
