import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEDF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA55166),
        title: const Text('SkinMuse'),
      ),
      body: const Center(
        child: Text(
          'Welcome to home SkinMuse!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
