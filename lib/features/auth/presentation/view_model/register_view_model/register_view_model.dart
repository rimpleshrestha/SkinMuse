import 'package:flutter/material.dart';

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

  // Simulated register function
  Future<bool> register() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    // Basic password match check (replace with real logic later)
    return _password == _confirmPassword && _email.isNotEmpty;
  }
}
