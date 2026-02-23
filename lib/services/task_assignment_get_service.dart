import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class TaskAssignmentGetService {
  Future<Map<String, dynamic>> getSingleTaskDetails(String taskId) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}project_api.get_single_task_details?task_id=$taskId',
      );

      print("========== API REQUEST ==========");
      print("URL: $url");

      final response = await http.get(url);

      print("========== API RESPONSE ==========");
      print("Status Code: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("Raw Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        print("========== DECODED JSON ==========");
        print(decodedData);

        // Safe navigation (avoid crash if structure changes)
        final outerMessage = decodedData['message'];
        print("Outer Message: $outerMessage");

        final innerMessage = outerMessage != null
            ? outerMessage['message']
            : null;
        print("Inner Message: $innerMessage");

        if (innerMessage != null && innerMessage['success'] == true) {
          print("Task Data: ${innerMessage['data']}");
          return {'success': true, 'data': innerMessage['data']};
        } else {
          print("API returned success = false");
          return {
            'success': false,
            'error': innerMessage?['message'] ?? 'Failed to fetch task details',
          };
        }
      } else {
        print("Server Error: ${response.reasonPhrase}");
        return {
          'success': false,
          'error': 'Server error: ${response.reasonPhrase}',
        };
      }
    } catch (e, stack) {
      print("========== EXCEPTION ==========");
      print("Error: $e");
      print("Stack: $stack");

      return {'success': false, 'error': 'Error: ${e.toString()}'};
    }
  }
}
