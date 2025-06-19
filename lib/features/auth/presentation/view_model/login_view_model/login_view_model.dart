import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';

class LoginViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  // Getters
  String get email => _email;
  String get password => _password;
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

  Future<UserHiveModel?> validateUser() async {
    final userBox = await Hive.openBox<UserHiveModel>('users');

    for (var u in userBox.values) {
      if (u.email == _email && u.password == _password) {
        return u; // Return the found user
      }
    }

    return null; // Return null if not found
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
