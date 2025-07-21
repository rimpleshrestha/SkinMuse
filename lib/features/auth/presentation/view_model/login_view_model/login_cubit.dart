import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:skin_muse/main.dart'; // for flutterLocalNotificationsPlugin
import 'package:hive/hive.dart';

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

    if (response != null && response['accessToken'] != null) {
      // Save token and user ID to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', response['accessToken']);
      await prefs.setString('userId', response['_id'] ?? '');

      // Create Hive model
      final user = UserHiveModel(
        userId: response['_id'] ?? '',
        firstName: response['firstName'] ?? '',
        lastName: response['lastName'] ?? '',
        phone: response['phone'] ?? '',
        profileImage: response['profileImage'],
        email: response['email'] ?? '',
        username: response['username'] ?? '',
        password: '', // We don't store password
      );

      // Save user to Hive
      final box = Hive.box<UserHiveModel>('users');
      await box.clear(); // optional: clear previous user
      await box.add(user);

      emit(LoginState.success(user));

      // Trigger a login success notification
      const androidDetails = AndroidNotificationDetails(
        'login_channel',
        'Login Notifications',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

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

  // ✅ Load user from Hive box at app start
  Future<void> loadUserFromStorage() async {
    final box = Hive.box<UserHiveModel>('users');
    if (box.isNotEmpty) {
      final user = box.getAt(0);
      if (user != null) {
        emit(LoginState.success(user));
      }
    }
  }
}
