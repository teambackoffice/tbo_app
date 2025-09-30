// To parse this JSON data, do
//
//     final notificationModal = notificationModalFromJson(jsonString);

import 'dart:convert';

NotificationModal notificationModalFromJson(String str) =>
    NotificationModal.fromJson(json.decode(str));

String notificationModalToJson(NotificationModal data) =>
    json.encode(data.toJson());

class NotificationModal {
  NotificationModalMessage message;

  NotificationModal({required this.message});

  factory NotificationModal.fromJson(Map<String, dynamic> json) =>
      NotificationModal(
        message: NotificationModalMessage.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {"message": message.toJson()};
}

class NotificationModalMessage {
  MessageMessage message;
  bool success;

  NotificationModalMessage({required this.message, required this.success});

  factory NotificationModalMessage.fromJson(Map<String, dynamic> json) =>
      NotificationModalMessage(
        message: MessageMessage.fromJson(json["message"]),
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "success": success,
  };
}

class MessageMessage {
  List<Title> title;
  String msg;
  Pagination pagination;

  MessageMessage({
    required this.title,
    required this.msg,
    required this.pagination,
  });

  factory MessageMessage.fromJson(Map<String, dynamic> json) => MessageMessage(
    title: List<Title>.from(json["Title"].map((x) => Title.fromJson(x))),
    msg: json["msg"],
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "Title": List<dynamic>.from(title.map((x) => x.toJson())),
    "msg": msg,
    "pagination": pagination.toJson(),
  };
}

class Pagination {
  int currentPage;
  int nextPage;
  String prevPage;
  int totalPages;
  int totalRecords;

  Pagination({
    required this.currentPage,
    required this.nextPage,
    required this.prevPage,
    required this.totalPages,
    required this.totalRecords,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["current_page"],
    nextPage: json["next_page"],
    prevPage: json["prev_page"],
    totalPages: json["total_pages"],
    totalRecords: json["total_records"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "next_page": nextPage,
    "prev_page": prevPage,
    "total_pages": totalPages,
    "total_records": totalRecords,
  };
}

class Title {
  DateTime dateTime;
  ForUser forUser;
  String documentName;
  DocumentType documentType;
  String emailContent;
  String profilePicture;

  Title({
    required this.dateTime,
    required this.forUser,
    required this.documentName,
    required this.documentType,
    required this.emailContent,
    required this.profilePicture,
  });

  factory Title.fromJson(Map<String, dynamic> json) => Title(
    dateTime: DateTime.parse(json["date_time"]),
    forUser: forUserValues.map[json["for_user"]]!,
    documentName: json["document_name"],
    documentType: documentTypeValues.map[json["document_type"]]!,
    emailContent: json["email_content"],
    profilePicture: json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "date_time": dateTime.toIso8601String(),
    "for_user": forUserValues.reverse[forUser],
    "document_name": documentName,
    "document_type": documentTypeValues.reverse[documentType],
    "email_content": emailContent,
    "profile_picture": profilePicture,
  };
}

enum DocumentType { EMPLOYEE_DATE_REQUEST, TASK }

final documentTypeValues = EnumValues({
  "Employee Date Request": DocumentType.EMPLOYEE_DATE_REQUEST,
  "Task": DocumentType.TASK,
});

enum ForUser { EMPLOY_GMAIL_COM }

final forUserValues = EnumValues({
  "employ@gmail.com": ForUser.EMPLOY_GMAIL_COM,
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
