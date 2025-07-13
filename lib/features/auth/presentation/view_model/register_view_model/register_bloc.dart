import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'register_event.dart';
import 'register_state.dart';
import '../../view_model/register_view_model/register_view_model.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterViewModel viewModel;
  final AuthRemoteDataSource _authRemoteDataSource;

  RegisterBloc({required this.viewModel, AuthRemoteDataSource? remote})
    : _authRemoteDataSource = remote ?? AuthRemoteDataSource(),
      super(const RegisterState.initial()) {
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

    if (event.password != event.confirmPassword) {
      emit(state.copyWith(isLoading: false, isSuccess: false));
      ScaffoldMessenger.of(
        event.context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    final message = await _authRemoteDataSource.register(
      event.email,
      event.password,
      event.confirmPassword,
    );

    print('Register result: $message');

    if (message != null) {
      emit(state.copyWith(isLoading: false, isSuccess: true));
      Navigator.of(event.context).pushReplacementNamed('/login');
    } else {
      emit(state.copyWith(isLoading: false, isSuccess: false));
      ScaffoldMessenger.of(
        event.context,
      ).showSnackBar(const SnackBar(content: Text('Registration failed')));
    }
  }
}
