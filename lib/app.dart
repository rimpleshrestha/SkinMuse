import 'package:flutter/material.dart';
import 'package:skin_muse/views/dashboard_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkinMuse',
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}
