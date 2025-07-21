import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'package:skin_muse/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:skin_muse/features/auth/presentation/bloc/editprofile/edit_profile_bloc.dart';

import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_cubit.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

import 'features/home/presentation/view/home_view.dart';
import 'features/splash/presentation/view/splash_view.dart';
import 'features/auth/presentation/view/register_view.dart';
import 'features/auth/presentation/view/login_view.dart';
import 'features/auth/presentation/view/edit_profile_view.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Notifications
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserHiveModelAdapter());
  await Hive.openBox<UserHiveModel>('users');

  // ✅ Create and load LoginCubit before runApp
  final loginCubit = LoginCubit(viewModel: LoginViewModel());
  await loginCubit.loadUserFromStorage();

  runApp(MyApp(loginCubit: loginCubit));
}

class MyApp extends StatelessWidget {
  final LoginCubit loginCubit;
  const MyApp({super.key, required this.loginCubit});

  @override
  Widget build(BuildContext context) {
    final authRemoteDataSource = AuthRemoteDataSource();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>.value(value: loginCubit),
        BlocProvider<ProfileBloc>(
          create:
              (_) => ProfileBloc(authRemoteDataSource: authRemoteDataSource),
        ),
        BlocProvider<EditProfileBloc>(
          create: (_) => EditProfileBloc(authRemoteDataSource),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashView(),
          '/register': (context) => const RegisterView(),
          '/login': (context) => const LoginView(),
          '/dashboard': (context) => const HomeView(),
          '/edit-profile': (context) => const EditProfileView(),
        },
      ),
    );
  }
}
