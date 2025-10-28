// lib/controller/handover_controller.dart
import 'package:flutter/material.dart';
import 'package:tbo_app/services/handover_task_post_service.dart';

class HandoverPostController with ChangeNotifier {
  final HandoverPostService _handoverService = HandoverPostService();

  bool _isLoading = false;
  String? _response;

  bool get isLoading => _isLoading;
  String? get response => _response;

  Future<void> handleHandover({
    required String name,
    required String action,
    required String toEmployee,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _handoverService.acceptOrRejectHandover(
        name: name,
        action: action,
        toEmployee: toEmployee,
      );

      _response = res ?? "Failed to process request";
    } catch (e) {
      _response = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
