import 'package:flutter/material.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';
import 'package:tbo_app/services/edit_lead_servcie.dart';

class EditLeadController with ChangeNotifier {
  final EditLeadService _service = EditLeadService();

  bool isLoading = false;
  String? message;

  Future<void> updateLeadStatus(String leadId, String status) async {
    isLoading = true;
    message = null;
    notifyListeners();

    final response = await _service.editLead(leadId: leadId, status: status);

    isLoading = false;

    if (response != null) {
      message = "✅ Lead updated successfully!";
    } else {
      message = "❌ Failed to update lead.";
    }

    notifyListeners();
  }

  void sendQuotation(Leads lead) {}
}
