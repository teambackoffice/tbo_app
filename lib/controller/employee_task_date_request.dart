import 'package:flutter/foundation.dart';
import 'package:tbo_app/modal/employee_task_date_request.dart';
import 'package:tbo_app/services/employee_task_date_request_service.dart';

class EmployeeTaskDateRequestController extends ChangeNotifier {
  final EmployeeTaskDateRequestService _service =
      EmployeeTaskDateRequestService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  EmployeeDateRequestModalClass? _dateRequestData;
  EmployeeDateRequestModalClass? get dateRequestData => _dateRequestData;

  Future<void> getEmployeeDateRequests({required String employeeId}) async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.fetchDateRequests(employeeId: employeeId);

    _dateRequestData = result;
    _isLoading = false;
    notifyListeners();
  }
}
