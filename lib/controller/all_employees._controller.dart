import 'package:flutter/material.dart';
import 'package:tbo_app/modal/all_employees.modal.dart';
import 'package:tbo_app/services/all_employees_service.dart';

class AllEmployeesController extends ChangeNotifier {
  final AllEmployeesService _service = AllEmployeesService();
  AllEmployeesModal? allEmployees;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchallemployees() async {
    _isLoading = true;
    notifyListeners();
    try {
      allEmployees = await _service.fetchAllEmployees();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
