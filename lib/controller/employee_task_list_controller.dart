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
      // Get employee ID from secure storage
      final employeeId = await _secureStorage.read(key: 'employee_id');

      if (employeeId == null) {
        throw Exception("No employee ID found in secure storage");
      }

      final response = await _taskService.getTaskListByEmployee(
        employeeId: employeeId,
      );

      if (response != null) {
        // The API returns nested structure: {"message": {"success_key": 1, "message": "Task List", "data": [...]}}
        final messageData = response['message'];
        if (messageData != null) {
          _taskListResponse = TaskListResponse.fromJson(messageData);
        }
      }
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
