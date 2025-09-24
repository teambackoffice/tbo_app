import 'package:flutter/material.dart';
import 'package:tbo_app/modal/employee_get_date_modal.dart';
import 'package:tbo_app/services/get_emloyee_date_service.dart';

class EmployeeDateRequestController extends ChangeNotifier {
  final EmployeeDateRequestService _service = EmployeeDateRequestService();

  bool isLoading = false;
  EmployeeDateRequestModal? requestData;
  String? errorMessage;

  Future<void> getEmployeeDateRequest() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _service.fetchEmployeeDateRequest();
    if (result != null) {
      requestData = result;
    } else {
      errorMessage = "Failed to fetch data";
    }

    isLoading = false;
    notifyListeners();
  }
}
