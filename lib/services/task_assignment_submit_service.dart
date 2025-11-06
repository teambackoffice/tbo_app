import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class TaskSubmissionService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final String baseUrl =
      "${ApiConstants.baseUrl}task_assignment_api.submit_employee_task_assignment";

  Future<String?> submitEmployeeTask({required String docName}) async {
    try {
      // ✅ Get SID from secure storage
      final sid = await _secureStorage.read(key: "sid");

      final uri = Uri.parse("$baseUrl?docname=$docName");

      var request = http.Request('GET', uri);

      // ✅ Add SID as cookie
      if (sid != null && sid.isNotEmpty) {
        request.headers['Cookie'] = 'sid=$sid';
      }

      http.StreamedResponse response = await request.send();

      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return responseBody;
      } else {
        return response.reasonPhrase;
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
