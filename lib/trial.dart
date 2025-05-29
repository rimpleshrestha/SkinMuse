import 'package:flutter/material.dart';

class Trial extends StatelessWidget {
  const Trial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Font Test')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'This is Inter Bold font',
              style: TextStyle(fontFamily: 'Inter_Bold', fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'This is Inter Light font',
              style: TextStyle(fontFamily: 'Inter_Light', fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
