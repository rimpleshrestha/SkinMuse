import 'package:flutter/material.dart';
import 'package:skin_muse/core/network/api_service.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart'; // You can remove if you won't use Hive
// Import your ApiService here

class RegisterViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;

  // Getters
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isLoading => _isLoading;

  // Setters
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    notifyListeners();
  }

  Future<bool> register() async {
    _isLoading = true;
    notifyListeners();

    // Call backend API for registration
    final success = await ApiService.registerUser(
      email: _email,
      password: _password,
      confirmPassword: _confirmPassword,
    );

    _isLoading = false;
    notifyListeners();

    return success;
  }
}
