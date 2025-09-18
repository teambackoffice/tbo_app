import 'package:flutter/material.dart';
import 'package:tbo_app/modal/employee_assignment_modal.dart';
import 'package:tbo_app/services/employee_assignments_servvice.dart';

class EmployeeAssignmentsController extends ChangeNotifier {
  final EmployeeAssignmentsService _service = EmployeeAssignmentsService();
  EmployeeAssignments? allLeads;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> feetchemployeeassignments({required String projectId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      allLeads = await _service.fetchemployeeassignments(projectId: projectId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
