// import 'package:flutter/material.dart';
// import 'sign_up.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Logo or title
//                 Image.asset('assets/skinmuselogo.png', height: 300),

//                 const SizedBox(height: 24),

//                 // Email Field
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                 ),

//                 const SizedBox(height: 20),

//                 // Password Field
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   obscureText: true,
//                 ),

//                 const SizedBox(height: 32),

//                 // Login Button
//                 ElevatedButton(
//                   onPressed: () {
//                     // Add login logic
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 32,
//                       vertical: 14,
//                     ),
//                     backgroundColor: const Color(0xFFA55166),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   child: const Text(
//                     'Login',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 100),

//                 // Don't have an account? Sign Up!
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Don't have an account? ",
//                       style: TextStyle(fontSize: 16, color: Colors.black),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) =>const SignUp()),
//                           );
//                         print("Navigate to Sign Up page");
//                       },
//                       child: const Text(
//                         "Sign Up!",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFFA55166),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
