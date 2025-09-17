import 'package:flutter/material.dart';
import 'package:tbo_app/services/create_project_service.dart';

class CreateProjectController extends ChangeNotifier {
  final CreateProjectService _service = CreateProjectService();

  bool _isLoading = false;
  String _responseMessage = '';

  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

  Future<void> updateProject({
    required String planningId,
    required String planningName,
    required String lead,
    required String leadSegment,
    required String projectType,
    required String status,
    required String planningDate,
    required int estimatedDuration,
    required double estimatedCost,
    required String plannedStartDate,
    required String plannedEndDate,
    required List<Map<String, dynamic>> resourceRequirements,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.createProject(
        planningId: planningId,
        planningName: planningName,
        lead: lead,
        leadSegment: leadSegment,
        projectType: projectType,
        status: status,
        planningDate: planningDate,
        estimatedDuration: estimatedDuration,
        estimatedCost: estimatedCost,
        plannedStartDate: plannedStartDate,
        plannedEndDate: plannedEndDate,
        resourceRequirements: resourceRequirements,
      );

      _responseMessage = response;
    } catch (e) {
      _responseMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
