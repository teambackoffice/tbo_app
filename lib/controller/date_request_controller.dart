import 'package:flutter/material.dart';
import 'package:tbo_app/services/date_requst_service.dart';

class CreateDateRequestController with ChangeNotifier {
  final TaskDateRequestService _service = TaskDateRequestService();

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? responseData;

  Future<void> createEmployeeDateRequest({
    required String employee,
    required String task,
    required String requestedStartDate,
    required String requestedEndDate,
    required String reason,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _service.createdaterequest(
        employee: employee,
        task: task,
        requestedStartDate: requestedStartDate,
        requestedEndDate: requestedEndDate,
        reason: reason,
      );

      responseData = result;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
