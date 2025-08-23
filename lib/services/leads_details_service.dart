import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';
import 'package:tbo_app/modal/leads_details_modal.dart';

class AllLeadsDetailsService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<AllLeadsDetailsModal> fetchLeadDetails({
    required String leadId,
  }) async {
    final String url = '${ApiConstants.baseUrl}lead_api.get_lead_details';

    try {
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception('Authentication required. Please login again.');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      // ✅ Add leadId as query param
      final uri = Uri.parse(url).replace(queryParameters: {'lead_id': leadId});

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);

          final leadDetails = AllLeadsDetailsModal.fromJson(decoded);

          return leadDetails;
        } catch (e) {
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception(
          'Failed to load lead details. Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
