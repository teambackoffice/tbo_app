import 'package:flutter/foundation.dart';
import 'package:tbo_app/services/employee_datetask_sumbit_service.dart';

class SubmitDateRequestController extends ChangeNotifier {
  final SubmitDateRequestService _service = SubmitDateRequestService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _response;
  Map<String, dynamic>? get response => _response;

  Future<void> submitDateRequest({
    required String requestId,
    String? requestedEndDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.submitDateRequest(
      requestId: requestId,
      requestedEndDate: requestedEndDate,
    );

    _response = result;
    _isLoading = false;
    notifyListeners();
  }
}
