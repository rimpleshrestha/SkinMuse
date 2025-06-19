import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';

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
    print('Register started for email: $_email');

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final isValid = _password == _confirmPassword && _email.isNotEmpty;
    if (!isValid) {
      print('Validation failed: passwords do not match or email empty');
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final userBox = await Hive.openBox<UserHiveModel>('users');

    UserHiveModel? existingUser;
    for (var user in userBox.values) {
      if (user.email == _email) {
        existingUser = user;
        break;
      }
    }

    if (existingUser != null) {
      print('User already exists with email $_email');
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final newUser = UserHiveModel(
      firstName: '',
      lastName: '',
      phone: '',
      email: _email,
      username: _email.split('@')[0],
      password: _password,
    );

    await userBox.add(newUser);

    print('User registered successfully: $_email');

    _isLoading = false;
    notifyListeners();

    return true;
  }
}
