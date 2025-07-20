import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'package:skin_muse/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';
import 'features/home/presentation/view/home_view.dart';
import 'features/splash/presentation/view/splash_view.dart';
import 'features/auth/presentation/view/register_view.dart';
import 'features/auth/presentation/view/login_view.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize AuthRemoteDataSource here
    final authRemoteDataSource = AuthRemoteDataSource();

    return BlocProvider(
      create: (_) => ProfileBloc(authRemoteDataSource: authRemoteDataSource),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashView(),
          '/register': (context) => const RegisterView(),
          '/login': (context) => const LoginView(),
          '/dashboard': (context) => const HomeView(),
          // Add more routes here if needed
        },
      ),
    );
  }
}
