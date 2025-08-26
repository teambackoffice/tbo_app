import 'package:flutter/material.dart';
import 'package:tbo_app/services/create_project_service.dart';

class CreateProjectController with ChangeNotifier {
  final CreateProjectService _service = CreateProjectService();

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? responseData;

  Future<void> createProject({
    required String projectName,
    required String status,
    required String startDate,
    required String endDate,
    required String projectType,
    required String priority,
    required String department,
    String? notes,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      responseData = await _service.createProject(
        projectName: projectName,
        status: status,
        startDate: startDate,
        endDate: endDate,
        projectType: projectType,
        priority: priority,
        department: department,
        notes: notes,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
