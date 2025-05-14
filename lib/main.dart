import 'package:flutter/material.dart';
import 'splash.dart';
import 'login_screen.dart';
 // Make sure the import is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), //splash screen
    );
  }
}
