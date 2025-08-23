// To parse this JSON data, do
//
//     final allEmployeesModal = allEmployeesModalFromJson(jsonString);

import 'dart:convert';

AllEmployeesModal allEmployeesModalFromJson(String str) =>
    AllEmployeesModal.fromJson(json.decode(str));

String allEmployeesModalToJson(AllEmployeesModal data) =>
    json.encode(data.toJson());

class AllEmployeesModal {
  List<Message> message;

  AllEmployeesModal({required this.message});

  factory AllEmployeesModal.fromJson(Map<String, dynamic> json) =>
      AllEmployeesModal(
        message: List<Message>.from(
          json["message"].map((x) => Message.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "message": List<dynamic>.from(message.map((x) => x.toJson())),
  };
}

class Message {
  String name;
  String employeeName;
  String department;
  String designation;
  String image;
  String imageUrl;

  Message({
    required this.name,
    required this.employeeName,
    required this.department,
    required this.designation,
    required this.image,
    required this.imageUrl,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    name: json["name"],
    employeeName: json["employee_name"],
    department: json["department"],
    designation: json["designation"],
    image: json["image"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "employee_name": employeeName,
    "department": department,
    "designation": designation,
    "image": image,
    "image_url": imageUrl,
  };
}
