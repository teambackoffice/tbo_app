import 'package:flutter/material.dart';
import 'package:tbo_app/services/task_count_service.dart';

class TaskCountController extends ChangeNotifier {
  final TaskCountService _service = TaskCountService();

  bool isLoading = false;
  Map<String, dynamic>? taskSummaryData;
  String? errorMessage;

  // Removed the unused 'status' parameter from the controller's fetch method
  Future<void> fetchTaskSummary() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Called without the redundant status parameter
      final response = await _service.getTaskCount();
      taskSummaryData = response;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  int get openTask => taskSummaryData?['open'] ?? 0;
  int get workingTask => taskSummaryData?['working'] ?? 0;
  int get completedTask => taskSummaryData?['completed'] ?? 0;
}
