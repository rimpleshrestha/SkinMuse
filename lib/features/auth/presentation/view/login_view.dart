import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/features/Admin/view/admin_post_view.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_cubit.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:skin_muse/features/home/presentation/view/home_view.dart';
import 'package:skin_muse/features/home/presentation/view_model/home_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;

  // Helper to decode JWT payload and extract user id (no underscore)
  String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> payloadMap = jsonDecode(decoded);
      // Extract 'id' as per your JWT payload
      return payloadMap['id'] as String?;
    } catch (_) {
      return null;
    }
  }

  // Optional debug print of JWT payload
  void debugPrintJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        print('Invalid JWT token');
        return;
      }
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      print('Decoded JWT payload: $decoded');
    } catch (e) {
      print('Error decoding JWT: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = LoginViewModel();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => loginViewModel),
        BlocProvider(create: (_) => LoginCubit(viewModel: loginViewModel)),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Consumer<LoginViewModel>(
                builder: (context, viewModel, _) {
                  return BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) async {
                      if (state.status == LoginStatus.success) {
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('accessToken');

                        if (token != null && token.isNotEmpty) {
                          debugPrintJwt(token);
                        }

                        final userRole = state.user?.role ?? '';
                        print('DEBUG: Logged in user role = $userRole');

                        final userIdFromToken =
                            token != null
                                ? _extractUserIdFromToken(token)
                                : null;
                        print(
                          'DEBUG: Extracted userId from token: $userIdFromToken',
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Successfully logged in"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        if (userRole == 'admin') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => AdminPostView(
                                    userEmail: state.user?.email ?? '',
                                    userId: userIdFromToken ?? '',
                                  ),
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => BlocProvider(
                                    create: (_) => HomeViewModel(),
                                    child: HomeView(
                                      email: state.user?.email ?? '',
                                    ),
                                  ),
                            ),
                          );
                        }
                      } else if (state.status == LoginStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Wrong credentials"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final cubit = context.read<LoginCubit>();

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/skinmuselogo.png', height: 300),
                          const SizedBox(height: 24),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: viewModel.setEmail,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFFA55166),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            onChanged: viewModel.setPassword,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed:
                                state.status == LoginStatus.loading
                                    ? null
                                    : () => cubit.login(),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              backgroundColor: const Color(0xFFA55166),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child:
                                state.status == LoginStatus.loading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                          const SizedBox(height: 100),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/register',
                                  );
                                },
                                child: const Text(
                                  "Sign Up!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFA55166),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
