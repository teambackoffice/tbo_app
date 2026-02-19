import 'package:flutter/material.dart';
import 'package:tbo_app/modal/get_admin_task_list_modal.dart';
import 'package:tbo_app/services/%20get_admin_Task_list_service.dart';

class GetAdminTaskListController extends ChangeNotifier {
  final GetAdminTaskListService _service = GetAdminTaskListService();

  GetAdminTaskListModalClass? projectDetails;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchProjectDetails({required String projectId}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _service.getProjectDetails(projectId: projectId);

      projectDetails = response;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
