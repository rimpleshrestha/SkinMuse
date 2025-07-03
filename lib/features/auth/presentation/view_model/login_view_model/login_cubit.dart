import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:skin_muse/main.dart'; // To access the notification instance
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSource();

  LoginCubit({required this.viewModel}) : super(LoginState.initial());

  Future<void> login() async {
    emit(LoginState.loading());
    viewModel.setLoading(true);

    final response = await _authRemoteDataSource.login(
      viewModel.email,
      viewModel.password,
    );

    viewModel.setLoading(false);

    if (response != null) {
      final user = UserHiveModel(
        firstName: response['firstName'] ?? '',
        lastName: response['lastName'] ?? '',
        phone: response['phone'] ?? '',
        profileImage: response['profileImage'],
        email: response['email'] ?? '',
        username: response['username'] ?? '',
        password: '',
      );

      emit(LoginState.success(user));

      // Show login notification
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'login_channel',
            'Login Notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        'Welcome to SkinMuse',
        'You just logged into SkinMuse',
        notificationDetails,
      );
    } else {
      emit(LoginState.failure());
    }
  }
}
