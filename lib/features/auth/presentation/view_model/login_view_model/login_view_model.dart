import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  // Getters
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;

  // Setters with notifyListeners
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  // Simulate login function
  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // simulate network delay

    _isLoading = false;
    notifyListeners();

    // Here add your actual login logic
    // Return true if login success, else false
    if (_email == 'test@example.com' && _password == '123456') {
      return true;
    } else {
      return false;
    }
  }
}
