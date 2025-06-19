import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final UserHiveModel? user;

  LoginState({required this.status, this.user});

  factory LoginState.initial() => LoginState(status: LoginStatus.initial);
  factory LoginState.loading() => LoginState(status: LoginStatus.loading);
  factory LoginState.success(UserHiveModel user) =>
      LoginState(status: LoginStatus.success, user: user);
  factory LoginState.failure() => LoginState(status: LoginStatus.failure);
}

class LoginCubit extends Cubit<LoginState> {
  final LoginViewModel viewModel;

  LoginCubit({required this.viewModel}) : super(LoginState.initial());

  Future<void> login() async {
    emit(LoginState.loading());
    viewModel.setLoading(true);

    final user = await viewModel.validateUser();

    viewModel.setLoading(false);

    if (user != null) {
      emit(LoginState.success(user));
    } else {
      emit(LoginState.failure());
    }
  }
}
