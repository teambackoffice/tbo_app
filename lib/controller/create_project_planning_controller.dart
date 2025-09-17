import 'package:flutter/material.dart';
import 'package:tbo_app/services/create_project_planning.dart';

class ProjectPlanningController extends ChangeNotifier {
  final CreateProjectPlanningService _service = CreateProjectPlanningService();

  bool _isLoading = false;
  String _responseMessage = '';

  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

  Future<String> createProjectPlanning({
    // CHANGE: void to String
    required String planningName,
    required String leadSegment,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String response = await _service.createProjectPlanning(
        // CHANGE: Get the response
        planningName: planningName,
        leadSegment: leadSegment,
      );
      _responseMessage = 'Project planning created successfully.';
      return response; // CHANGE: Return the response
    } catch (e) {
      _responseMessage = e.toString();
      rethrow; // CHANGE: Rethrow the error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
