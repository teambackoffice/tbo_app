import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tbo_app/modal/employee_task_list_modal.dart';
import 'package:tbo_app/services/employee_task_list_service.dart';

class TaskByEmployeeController with ChangeNotifier {
  final TaskService _taskService = TaskService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TaskListResponse? _taskListResponse;
  TaskListResponse? get taskListResponse => _taskListResponse;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final employeeId = await _secureStorage.read(key: 'employee_id');

      if (employeeId == null) {
        throw Exception("No employee ID found in secure storage");
      }

      final response = await _taskService.getTaskListByEmployee(
        employeeId: employeeId,
      );

      if (response != null) {
        // ✅ Pass the whole response to the model, not just 'message'
        _taskListResponse = TaskListResponse.fromJson(response);
      } else {}
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
