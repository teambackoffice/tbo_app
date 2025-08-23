import 'package:flutter/material.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';
import 'package:tbo_app/services/all_lead_list_service.dart';

class AllLeadListController extends ChangeNotifier {
  final AllLeadListService _service = AllLeadListService();
  AllLeadsModal? allLeads;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchallleadlist() async {
    _isLoading = true;
    notifyListeners();
    try {
      allLeads = await _service.fetchallleadlist();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
