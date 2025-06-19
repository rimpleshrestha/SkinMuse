import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';
import 'features/home/presentation/view/home_view.dart';
import 'features/splash/presentation/view/splash_view.dart';
import 'features/auth/presentation/view/register_view.dart';
import 'features/auth/presentation/view/login_view.dart';
// replace with your actual import path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register your adapter
  Hive.registerAdapter(UserHiveModelAdapter());

  // Open the box for users
  await Hive.openBox<UserHiveModel>('users');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashView(),
        '/register': (context) => const RegisterView(),
        '/login': (context) => const LoginView(),
        '/dashboard': (context) => const HomeView(),
      },
    );
  }
}
