// import 'package:flutter/material.dart';
// import 'login_screen.dart';

// class Splash extends StatefulWidget {
//   const Splash({super.key});

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> {
//   @override
//   void initState() {
//     super.initState();

//     // Wait for 3 seconds then navigate
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//          builder: (context) => const LoginScreen(),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFEDF5), // your custom pink shade
//       body: Center(child: Image.asset('assets/skinmuselogo.png', width: 500)),
//     );
//   }
// }

// // Dummy next screen (replace this with your actual home screen)
// class MyHomePage extends StatelessWidget {
//   final String title;
//   const MyHomePage({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: const Center(child: Text("Welcome to Skin Muse!")),
//     );
//   }
// }
