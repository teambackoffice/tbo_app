import 'dart:convert';

/// To parse JSON data:
/// final notificationModal = NotificationModal.fromJson(jsonDecode(jsonString));

NotificationModal notificationModalFromJson(String str) =>
    NotificationModal.fromJson(json.decode(str));

String notificationModalToJson(NotificationModal data) =>
    json.encode(data.toJson());

/// =================== Notification Modal ===================
class NotificationModal {
  final NotificationModalMessage message;

  NotificationModal({required this.message});

  /// Flattened notifications list for easy access
  List<Title> get notifications => message.message.title;

  factory NotificationModal.fromJson(Map<String, dynamic> json) {
    return NotificationModal(
      message: NotificationModalMessage.fromJson(json['message'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {'message': message.toJson()};
}

/// =================== Notification Modal Message ===================
class NotificationModalMessage {
  final MessageMessage message;
  final bool success;

  NotificationModalMessage({required this.message, required this.success});

  factory NotificationModalMessage.fromJson(Map<String, dynamic> json) {
    return NotificationModalMessage(
      message: MessageMessage.fromJson(json['message'] ?? {}),
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message.toJson(),
    'success': success,
  };
}

/// =================== Inner Message ===================
class MessageMessage {
  final List<Title> title;
  final String msg;
  final Pagination pagination;

  MessageMessage({
    required this.title,
    required this.msg,
    required this.pagination,
  });

  factory MessageMessage.fromJson(Map<String, dynamic> json) {
    return MessageMessage(
      title: (json['Title'] as List<dynamic>? ?? [])
          .map((x) => Title.fromJson(x))
          .toList(),
      msg: json['msg'] ?? '',
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'Title': title.map((x) => x.toJson()).toList(),
    'msg': msg,
    'pagination': pagination.toJson(),
  };
}

/// =================== Pagination ===================
class Pagination {
  final int currentPage;
  final dynamic nextPage;
  final dynamic prevPage;
  final int totalPages;
  final int totalRecords;

  Pagination({
    required this.currentPage,
    this.nextPage,
    this.prevPage,
    required this.totalPages,
    required this.totalRecords,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 0,
      nextPage: json['next_page'],
      prevPage: json['prev_page'],
      totalPages: json['total_pages'] ?? 0,
      totalRecords: json['total_records'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'next_page': nextPage,
    'prev_page': prevPage,
    'total_pages': totalPages,
    'total_records': totalRecords,
  };
}

/// =================== Notification Item ===================
class Title {
  final DateTime dateTime;
  final String forUser;
  final String documentName;
  final DocumentType documentType;
  final String emailContent;
  final String profilePicture;
  bool isRead;

  Title({
    required this.dateTime,
    required this.forUser,
    required this.documentName,
    required this.documentType,
    required this.emailContent,
    required this.profilePicture,
    this.isRead = false,
  });

  factory Title.fromJson(Map<String, dynamic> json) {
    return Title(
      dateTime: json['date_time'] != null
          ? DateTime.tryParse(json['date_time']) ?? DateTime.now()
          : DateTime.now(),
      forUser: json['for_user'] ?? '',
      documentName: json['document_name'] ?? '',
      documentType:
          documentTypeValues.map[json['document_type']] ?? DocumentType.UNKNOWN,
      emailContent: json['email_content'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'date_time': dateTime.toIso8601String(),
    'for_user': forUser,
    'document_name': documentName,
    'document_type': documentTypeValues.reverse[documentType],
    'email_content': emailContent,
    'profile_picture': profilePicture,
    'is_read': isRead,
  };

  Title copyWith({
    DateTime? dateTime,
    String? forUser,
    String? documentName,
    DocumentType? documentType,
    String? emailContent,
    String? profilePicture,
    bool? isRead,
  }) {
    return Title(
      dateTime: dateTime ?? this.dateTime,
      forUser: forUser ?? this.forUser,
      documentName: documentName ?? this.documentName,
      documentType: documentType ?? this.documentType,
      emailContent: emailContent ?? this.emailContent,
      profilePicture: profilePicture ?? this.profilePicture,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// =================== Document Type Enum ===================
enum DocumentType {
  EMPLOYEE_DATE_REQUEST,
  TASK,
  PUSH_NOTIFICATION_SETTINGS,
  UNKNOWN, // fallback for unknown types
}

final documentTypeValues = EnumValues({
  "Employee Date Request": DocumentType.EMPLOYEE_DATE_REQUEST,
  "Task": DocumentType.TASK,
  "Push Notification Settings": DocumentType.PUSH_NOTIFICATION_SETTINGS,
});

/// =================== EnumValues Helper ===================
class EnumValues<T> {
  final Map<String, T> map;
  late final Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
