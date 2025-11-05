import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class TaskAssignmentGetService {
  Future<Map<String, dynamic>> getSingleTaskDetails(String taskId) async {
    try {
      // Build the request URL
      final url = Uri.parse(
        '${ApiConstants.baseUrl}project_api.get_single_task_details?task_id=$taskId',
      );

      // Send GET request
      final response = await http.get(url);

      // Parse response
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        // Navigate through the nested structure
        final messageData = decodedData['message']['message'];

        if (messageData['success'] == true) {
          return {'success': true, 'data': messageData['data']};
        } else {
          return {'success': false, 'error': 'Failed to fetch task details'};
        }
      } else {
        return {
          'success': false,
          'error': 'Server error: ${response.reasonPhrase}',
        };
      }
    } catch (e, stack) {
      return {'success': false, 'error': 'Error: ${e.toString()}'};
    }
  }
}
