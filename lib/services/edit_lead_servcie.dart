import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tbo_app/config/api_constants.dart';

class EditLeadService {
  final String _url = '${ApiConstants.baseUrl}lead_api.edit_lead';

  Future<Map<String, dynamic>?> editLead({
    required String leadId,
    required String status,
  }) async {
    try {
      var headers = {'Content-Type': 'application/json'};

      var body = json.encode({"lead_id": leadId, "status": status});

      var request = http.Request('POST', Uri.parse(_url));
      request.body = body;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final decoded = json.decode(resBody);

        return decoded;
      } else {
        final errorBody = await response.stream.bytesToString();

        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
