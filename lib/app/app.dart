import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/app/theme/app_theme.dart';
import 'package:skin_muse/app/service_locator/service_locator.dart';
import 'package:skin_muse/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:skin_muse/views/splash.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkinMuse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getApplicationTheme(isDarkMode: false),
      home: BlocProvider.value(
        value: serviceLocator<SplashViewModel>(),
        child: const Splash(),
      ),
    );
  }
}
