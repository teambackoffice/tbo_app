import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class HandoverPostService {
  // Initialize Flutter Secure Storage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> acceptOrRejectHandover({
    required String name,
    required String action,
    required String toEmployee,
  }) async {
    try {
      // 🔐 Read session ID (sid) from secure storage
      final sessionId = await _storage.read(key: 'sid');

      if (sessionId == null || sessionId.isEmpty) {
        return null;
      }

      // 🌐 Build the full API URL
      final url = Uri.parse(
        "${ApiConstants.baseUrl}task_assignment_api.accept_handover_request"
        "?name=$name&action=$action&to_employee=$toEmployee",
      );

      // 🧾 Prepare GET request
      var request = http.Request('GET', url);
      request.headers.addAll({
        'Cookie': 'sid=$sessionId',
        'Content-Type': 'application/json',
      });

      // 🚀 Send the request
      final response = await request.send();

      // 📦 Read the response body
      final responseBody = await response.stream.bytesToString();

      // ✅ Handle response
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        return null;
      }
    } catch (e, stack) {
      return null;
    }
  }
}
