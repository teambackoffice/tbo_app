// lib/controllers/timesheet_status_controller.dart
import 'package:flutter/material.dart';
import 'package:tbo_app/services/update_timesheet_service.dart';

class TimesheetStatusController with ChangeNotifier {
  final UpdateTimesheetStatusService _service = UpdateTimesheetStatusService();

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? result;

  /// Updates the timesheet status using API
  Future<void> updateStatus({
    required String timesheetId,
    required String action,
    String? sid,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _service.updateTimesheetStatus(
        timesheetId: timesheetId,
        action: action,
      );

      if (response != null && response["success"] == true) {
        result = response["data"];
      } else {
        errorMessage = response?["message"] ?? "Failed to update timesheet.";
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
