import 'dart:convert';

import 'package:http/http.dart' as http;

class PostNotificationService {
  static const String _oneSignalAppId = "6a1f3d55-06a2-4260-81fd-95f4f41ab003";
  static const String _restApiKey =
      "os_v2_app_nipt2vigujbgbap5sx2pigvqapjnbvgj3xnum4uw4wrkbomf77hxrj4q4mzn6ckshfrwl7mivuqqhzqjns4uji7adozjurrximfvwzq";

  static Future<bool> sendTaskAssignmentNotification({
    required String employeeEmail,
    required String taskSubject,
    required String taskId,
    String? assignerName,
  }) async {
    try {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🔔 SENDING NOTIFICATION');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📋 Employee Email: $employeeEmail');
      print('📝 Task: $taskSubject');
      print('🆔 Task ID: $taskId');
      print('👤 Assigner: $assignerName');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final requestBody = {
        'app_id': _oneSignalAppId,
        'include_external_user_ids': [employeeEmail],
        'contents': {
          'en': assignerName != null
              ? '$assignerName assigned you a new task: $taskSubject'
              : 'You have been assigned to: $taskSubject',
        },
        'headings': {'en': 'New Task Assignment'},
        'data': {
          'type': 'task_assignment',
          'task_id': taskId,
          'task_subject': taskSubject,
        },
        // Removed android_channel_id - it will use the default channel
      };

      print('📤 Request Body:');
      print(jsonEncode(requestBody));

      final response = await http.post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Basic $_restApiKey',
        },
        body: jsonEncode(requestBody),
      );

      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('📥 RESPONSE');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        print('✅ SUCCESS! Recipients: ${responseData["recipients"]}');

        if (responseData['recipients'] == 0) {
          print('⚠️ WARNING: 0 recipients found!');
          print('Employee "$employeeEmail" is not registered with OneSignal');
          print(
            'Make sure the employee has logged in and OneSignal.login() was called',
          );
        }

        return true;
      } else {
        print('❌ FAILED: Status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ EXCEPTION: $e');
      return false;
    }
  }
}
