import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/employee_get_date_modal.dart';

class EmployeeDateRequestService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<EmployeeDateRequestModal?> fetchEmployeeDateRequest() async {
    try {
      final String? sid = await _secureStorage.read(key: 'sid');
      if (sid == null) return null;

      var request = http.Request(
        'GET',
        Uri.parse(
          '${ApiConstants.baseUrl}task_assignment_api.get_employee_date_request',
        ),
      );

      request.headers.addAll({
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        return employeeDateRequestModalFromJson(responseBody);
      } else {
        print("Error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
