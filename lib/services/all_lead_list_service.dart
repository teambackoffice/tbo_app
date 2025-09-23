import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';

class AllLeadListService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<AllLeadsModal> fetchAllLeadList({String? status}) async {
    try {
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception('Authentication required. Please login again.');
      }

      // Build URI with optional status param
      final uri = Uri.parse('${ApiConstants.baseUrl}lead_api.get_lead_list')
          .replace(
            queryParameters: status != null && status.isNotEmpty
                ? {'status': status}
                : null,
          );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'},
      );

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);

          final model = AllLeadsModal.fromJson(decoded);
          return model;
        } catch (e) {
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
          'Failed to load leads. Code: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
