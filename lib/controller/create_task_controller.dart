import 'package:flutter/material.dart';

import '../services/create_task_service.dart';

class CreateTaskController extends ChangeNotifier {
  final CreateTaskService _service = CreateTaskService();

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? responseData;

  Future<void> createTask({
    required String project,
    required String subject,
    required String assignedEmployee,
    required String priority,
    required String description,
    required String expStartDate,
    required String expEndDate,
    required String status,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      responseData = await _service.createTask(
        project: project,
        subject: subject,
        assignedEmployee: assignedEmployee,
        priority: priority,
        description: description,
        expStartDate: expStartDate,
        expEndDate: expEndDate,
        status: status,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
