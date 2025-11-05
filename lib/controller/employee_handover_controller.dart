import 'package:flutter/material.dart';
import 'package:tbo_app/services/employee_handover_request_service.dart';

class TaskHandoverController extends ChangeNotifier {
  final TaskHandoverService _service = TaskHandoverService();

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? responseData;

  Future<void> createHandover({
    required String fromEmployee,
    required String toEmployee,
    required String task,
    required String employeeTask,
    required String handoverReason,
    required String handoverNotes,
    required String handoverType,
    String? leaveStartDate,
    String? leaveEndDate,
  }) async {
    isLoading = true;
    errorMessage = null;
    responseData = null;
    notifyListeners();

    try {
      final data = await _service.createTaskHandoverRequest(
        fromEmployee: fromEmployee,
        toEmployee: toEmployee,
        task: task,
        employeeTask: employeeTask,
        handoverReason: handoverReason,
        handoverNotes: handoverNotes,
        handoverType: handoverType,
        leaveStartDate: leaveStartDate,
        leaveEndDate: leaveEndDate,
      );

      responseData = data;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
