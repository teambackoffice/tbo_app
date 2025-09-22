import 'package:flutter/material.dart';
import 'package:tbo_app/services/create_new_lead_service.dart';

class CreateNewLeadController extends ChangeNotifier {
  final CreateNewLeadService _leadService = CreateNewLeadService();

  bool isLoading = false;
  Map<String, dynamic>? leadResponse;

  /// Returns `true` if lead creation was successful
  Future<bool> createLead(Map<String, dynamic> leadData) async {
    isLoading = true;
    notifyListeners();

    final response = await _leadService.createLead(leadData: leadData);

    leadResponse = response;
    isLoading = false;
    notifyListeners();

    if (response != null && response['success'] == true) {
      print('Lead ID: ${response['data']['lead_id']}');
      return true;
    } else {
      print('Failed to create lead. Response: $response');
      return false;
    }
  }
}
