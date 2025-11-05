import 'package:flutter/material.dart';
import 'package:tbo_app/services/task_assignment_get_service.dart';

class GetTaskAssignmentController extends ChangeNotifier {
  final TaskAssignmentGetService _service = TaskAssignmentGetService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _employeeTaskAssignmentId;
  String? _taskStatus;
  List<Map<String, dynamic>>? _taskAssignments;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get employeeTaskAssignmentId => _employeeTaskAssignmentId;
  String? get taskStatus => _taskStatus;
  List<Map<String, dynamic>>? get taskAssignments => _taskAssignments;

  Future<void> fetchTaskDetails(String taskId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _service.getSingleTaskDetails(taskId);

    if (result['success'] == true) {
      final data = result['data'];
      _employeeTaskAssignmentId = data['employee_task_assignment_id'];
      _taskStatus = data['status'];
      _taskAssignments = List<Map<String, dynamic>>.from(
        data['task_assignments'] ?? [],
      );
      _errorMessage = null;
    } else {
      _errorMessage = result['error'];
      _employeeTaskAssignmentId = null;
      _taskStatus = null;
      _taskAssignments = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
