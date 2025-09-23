import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/get_employee_handover_modal.dart';

class EmployeeHandoverService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<EmployeeHandOverModal?> fetchEmployeeHandover() async {
    try {
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception('Session ID not found');
      }

      var url = Uri.parse(
        '${ApiConstants.baseUrl}task_assignment_api.get_employee_handover_requests',
      );

      var request = http.Request('GET', url);
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        return employeeHandOverModalFromJson(responseString);
      } else {
        print('Error: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
