import 'package:flutter/material.dart';
import 'package:tbo_app/modal/leads_details_modal.dart';
import 'package:tbo_app/services/leads_details_service.dart';

class AllLeadsDetailsController extends ChangeNotifier {
  final AllLeadsDetailsService _service = AllLeadsDetailsService();
  AllLeadsDetailsModal? leadDetails;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLeadDetails({required String leadId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      leadDetails = await _service.fetchLeadDetails(leadId: leadId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
