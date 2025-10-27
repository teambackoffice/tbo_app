import 'package:flutter/material.dart';
import 'package:tbo_app/modal/project_list_modal.dart';
import 'package:tbo_app/services/project_list_service.dart';

class GetProjectListController extends ChangeNotifier {
  final ProjectListService _service = ProjectListService();
  ProjectList? projectList;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchprojectlist({String? status}) async {
    _isLoading = true;
    notifyListeners();
    try {
      projectList = await _service.fetchProjectList( status: status);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
