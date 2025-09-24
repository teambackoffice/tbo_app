import 'package:flutter/material.dart';
import 'package:tbo_app/modal/user_details_modal.dart';
import 'package:tbo_app/services/user_details_service.dart';

class UserDetailsController with ChangeNotifier {
  final UserDetailsService _userDetailsService = UserDetailsService();

  UserDetailsModal? _userDetails;
  bool _isLoading = false;
  String? _errorMessage;

  UserDetailsModal? get userDetails => _userDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getUserDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userDetails = await _userDetailsService.fetchUserDetails();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
