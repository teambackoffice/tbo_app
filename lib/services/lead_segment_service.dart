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

      print("🔹 FETCH LEAD SEGMENTS API CALL");
      print("🔹 URL: $url");
      print("🔹 Headers: $headers");

      final response = await http.get(Uri.parse(url), headers: headers);

      print("🔸 Status Code: ${response.statusCode}");
      print("🔸 Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);

          print("✅ Decoded JSON: $decoded");

          final leadsegments = LeadSegmentModal.fromJson(decoded);

          print("✅ Parsed Model Successfully");

          return leadsegments;
        } catch (e) {
          print("❌ JSON Parse Error: $e");
          throw Exception('Failed to parse response: $e');
        }
      } else {
        print("❌ API Error: ${response.statusCode} - ${response.body}");
        throw Exception(
          'Failed to load employees. Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("❌ Network/Unexpected Error: $e");
      throw Exception('Network error: $e');
    }
  }
}
