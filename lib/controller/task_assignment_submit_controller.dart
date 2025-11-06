import 'package:flutter/foundation.dart';
import 'package:tbo_app/services/task_assignment_submit_service.dart';

class TaskSubmissionController with ChangeNotifier {
  final TaskSubmissionService _service = TaskSubmissionService();

  bool isLoading = false;
  String? responseMessage;

  Future<void> submitEmployeeTask({required String docName}) async {
    isLoading = true;
    notifyListeners();

    responseMessage = await _service.submitEmployeeTask(docName: docName);

    isLoading = false;
    notifyListeners();
  }
}
