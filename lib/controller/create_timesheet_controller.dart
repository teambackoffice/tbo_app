import 'package:flutter/material.dart';
import 'package:tbo_app/services/create_timesheet_service.dart';

class CreateTimesheetController with ChangeNotifier {
  final CreateTimesheetService _timesheetService = CreateTimesheetService();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get response => _response;

  Future<void> createTimesheet({
    required String sid,
    required String employee,
    required String startDate,
    required String endDate,
    required List<Map<String, dynamic>> timeLogs,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _response = null;
    notifyListeners();

    try {
      final result = await _timesheetService.createTimesheet(
        sid: sid,
        employee: employee,
        startDate: startDate,
        endDate: endDate,
        timeLogs: timeLogs,
      );

      _response = result;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
