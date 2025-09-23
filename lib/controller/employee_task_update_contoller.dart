import 'package:flutter/material.dart';
import 'package:tbo_app/services/employee_task_status_update_service.dart';

class EditTaskController extends ChangeNotifier {
  final EditTaskService _service = EditTaskService();

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? responseData;

  Future<void> editTask({
    required String taskId,
    required String project,
    required String subject,
    required String status,
    required String priority,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.editTask(
        taskId: taskId,
        project: project,
        subject: subject,
        status: status,
        priority: priority,
      );
      responseData = result;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
