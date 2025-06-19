import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';
import '../../view_model/register_view_model/register_view_model.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterViewModel viewModel;

  RegisterBloc({required this.viewModel})
    : super(const RegisterState.initial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  Future<void> _onRegisterButtonPressed(
    RegisterButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    print('Register button pressed for email: ${event.email}');
    emit(state.copyWith(isLoading: true));

    viewModel.setEmail(event.email);
    viewModel.setPassword(event.password);
    viewModel.setConfirmPassword(event.confirmPassword);

    final success = await viewModel.register();

    print('Register result: $success');

    if (success) {
      emit(state.copyWith(isLoading: false, isSuccess: true));
      // Navigate to login screen on success
      Navigator.of(event.context).pushReplacementNamed('/login');
    } else {
      emit(state.copyWith(isLoading: false, isSuccess: false));
      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match or invalid email'),
        ),
      );
    }
  }
}
