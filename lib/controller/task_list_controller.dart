import 'package:flutter/material.dart';
import 'package:tbo_app/modal/task_list_modal.dart';
import 'package:tbo_app/services/task_list_service.dart';

class TaskListController extends ChangeNotifier {
  final TaskListService _service = TaskListService();
  AllTaskListModal? tasklist;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchtasklist({String? status, String? assignedUsers}) async {
    _isLoading = true;
    notifyListeners();
    try {
      tasklist = await _service.fetchtasklist(
        status: status,
        assignedUsers: assignedUsers,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
