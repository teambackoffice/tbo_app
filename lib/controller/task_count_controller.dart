import 'package:flutter/material.dart';
import 'package:tbo_app/services/task_count_service.dart';

class TaskCountController extends ChangeNotifier {
  final TaskCountService _service = TaskCountService();

  bool isLoading = false;
  Map<String, dynamic>? taskSummaryData;
  String? errorMessage;

  Future<void> fetchTaskSummary({required String status}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getTaskCount(status: status);
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
