// To parse this JSON data, do
//
//     final userDetailsModal = userDetailsModalFromJson(jsonString);

import 'dart:convert';

UserDetailsModal userDetailsModalFromJson(String str) =>
    UserDetailsModal.fromJson(json.decode(str));

String userDetailsModalToJson(UserDetailsModal data) =>
    json.encode(data.toJson());

class UserDetailsModal {
  Message message;

  UserDetailsModal({required this.message});

  factory UserDetailsModal.fromJson(Map<String, dynamic> json) =>
      UserDetailsModal(message: Message.fromJson(json["message"]));

  Map<String, dynamic> toJson() => {"message": message.toJson()};
}

class Message {
  int successKey;
  String message;
  User user;

  Message({
    required this.successKey,
    required this.message,
    required this.user,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    successKey: json["success_key"],
    message: json["message"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "success_key": successKey,
    "message": message,
    "user": user.toJson(),
  };
}

class User {
  String sid;
  String apiKey;
  String apiSecret;
  String? username;
  String? email;
  String? mobileNo;
  String employeeId;
  String employeeFullName;
  String? designation;
  String? image;

  User({
    required this.sid,
    required this.apiKey,
    required this.apiSecret,
    required this.username,
    required this.email,
    required this.mobileNo,
    required this.employeeId,
    required this.employeeFullName,
    required this.designation,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    sid: json["sid"],
    apiKey: json["api_key"],
    apiSecret: json["api_secret"],
    username: json["username"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    employeeId: json["employee_id"],
    employeeFullName: json["employee_full_name"],
    designation: json["designation"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "sid": sid,
    "api_key": apiKey,
    "api_secret": apiSecret,
    "username": username,
    "email": email,
    "mobile_no": mobileNo,
    "employee_id": employeeId,
    "employee_full_name": employeeFullName,
    "designation": designation,
    "image": image,
  };
}
