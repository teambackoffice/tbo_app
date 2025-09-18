import 'package:flutter/material.dart';
import 'package:tbo_app/modal/timesheet_modal.dart';
import 'package:tbo_app/services/get_timesheet_service.dart';

class GetTimesheetController extends ChangeNotifier {
  final GetTimesheetService _service = GetTimesheetService();
  TimesheetModal? allLeads;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchtimesheet({String? employee}) async {
    _isLoading = true;
    notifyListeners();
    try {
      allLeads = await _service.fetchtimesheet(employee: employee);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
