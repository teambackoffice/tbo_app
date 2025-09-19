import 'package:flutter/material.dart';
import 'package:tbo_app/services/task_employee_assign_service.dart';

class TaskEmployeeAssignController extends ChangeNotifier {
  final TaskEmployeeAssignService _service = TaskEmployeeAssignService();

  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _response;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get response => _response;

  Future<void> updateAssignmentEmployees({
    required String assignmentId,
    required List<Map<String, dynamic>> taskAssignments,
    required List<Map<String, dynamic>> subTaskAssignments,
  }) async {
    _isLoading = true;
    _error = null;
    _response = null;
    notifyListeners();

    try {
      final result = await _service.updateAssignmentEmployees(
        assignmentId: assignmentId,
        taskAssignments: taskAssignments,
        subTaskAssignments: subTaskAssignments,
      );
      _response = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
