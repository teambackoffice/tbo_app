import 'package:flutter/material.dart';
import 'package:tbo_app/modal/get_employee_handover_modal.dart';
import 'package:tbo_app/services/get_handover_service.dart';

class EmployeeHandoverController extends ChangeNotifier {
  final EmployeeHandoverService _service = EmployeeHandoverService();

  bool isLoading = false;
  EmployeeHandOverModal? handoverData;
  String? errorMessage;

  Future<void> getEmployeeHandover() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.fetchEmployeeHandover();
      if (result != null) {
        handoverData = result;
      } else {
        errorMessage = 'Failed to fetch data';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
