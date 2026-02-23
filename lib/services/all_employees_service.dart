import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/all_employees.modal.dart';

class AllEmployeesService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<AllEmployeesModal> fetchAllEmployees() async {
    final String url =
        '${ApiConstants.baseUrl}employee_api.get_employees_in_same_department';

    try {
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception('Authentication required. Please login again.');
      }

      print("========== API REQUEST ==========");
      print("URL: $url");
      print("SID: $sid");

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'},
      );

      print("========== API RESPONSE ==========");
      print("Status Code: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        print("========== DECODED JSON ==========");
        print(decoded);

        final employees = AllEmployeesModal.fromJson(decoded);

        print("========== PARSED MODEL ==========");
        print(employees);

        return employees;
      } else {
        throw Exception(
          'Failed to load employees. Code: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      print("========== ERROR ==========");
      print("Error: $e");
      print("StackTrace: $stackTrace");
      throw Exception('Network error: $e');
    }
  }
}
