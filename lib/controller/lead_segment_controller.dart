import 'package:flutter/material.dart';
import 'package:tbo_app/modal/lead_segment_modal.dart';
import 'package:tbo_app/services/lead_segment_service.dart';

class LeadSegmentController extends ChangeNotifier {
  final LeadSegmentService _service = LeadSegmentService();
  LeadSegmentModal? leadsegments;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchleadsegments() async {
    _isLoading = true;
    notifyListeners();
    try {
      leadsegments = await _service.fetchleadsegments();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
