import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class TaskSubmissionService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final String baseUrl =
      "${ApiConstants.baseUrl}task_assignment_api.submit_employee_task_assignment";

  Future<String?> submitEmployeeTask({required String docName}) async {
    try {
      // 🟦 Read SID
      final sid = await _secureStorage.read(key: "sid");

      final uri = Uri.parse("$baseUrl?docname=$docName");

      var request = http.Request('GET', uri);

      if (sid != null && sid.isNotEmpty) {
        request.headers['Cookie'] = 'sid=$sid';
      }

      // 🟦 Debug Headers

      http.StreamedResponse response = await request.send();

      String responseBody = await response.stream.bytesToString();

      // 🟦 Response Logs

      if (response.statusCode == 200) {
        return responseBody;
      } else {
        return "Error ${response.statusCode}: ${response.reasonPhrase}\nBody: $responseBody";
      }
    } catch (e, stack) {
      return "Exception: $e";
    }
  }
}
