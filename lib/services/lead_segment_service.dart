import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/lead_segment_modal.dart';

class LeadSegmentService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<LeadSegmentModal> fetchleadsegments() async {
    final String url =
        '${ApiConstants.baseUrl}task_assignment_api.get_task_template_groups';

    try {
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception('Authentication required. Please login again.');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);

          final leadsegments = LeadSegmentModal.fromJson(decoded);

          return leadsegments;
        } catch (e) {
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
          'Failed to load employees. Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
