import 'package:flutter/material.dart';

@immutable
sealed class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final BuildContext context;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterButtonPressed({
    required this.context,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}
