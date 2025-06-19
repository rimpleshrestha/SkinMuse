import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_bloc.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final registerViewModel = RegisterViewModel();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => registerViewModel),
        BlocProvider(create: (_) => RegisterBloc(viewModel: registerViewModel)),
      ],
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Consumer<RegisterViewModel>(
                builder: (context, viewModel, _) {
                  return BlocConsumer<RegisterBloc, RegisterState>(
                    listener: (context, state) {
                      if (state.isSuccess) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    builder: (context, state) {
                      final bloc = context.read<RegisterBloc>();

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo or title
                          Image.asset('assets/skinmuselogo.png', height: 300),

                          const SizedBox(height: 24),

                          // Email TextField
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Enter your email',
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

                          // Password TextField
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Enter a password',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            obscureText: true,
                            onChanged: viewModel.setPassword,
                          ),

                          const SizedBox(height: 20),

                          // Confirm Password TextField
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            obscureText: true,
                            onChanged: viewModel.setConfirmPassword,
                          ),

                          const SizedBox(height: 32),

                          // Sign Up Button
                          ElevatedButton(
                            onPressed:
                                state.isLoading
                                    ? null
                                    : () {
                                      bloc.add(
                                        RegisterButtonPressed(
                                          context: context,
                                          email: viewModel.email,
                                          password: viewModel.password,
                                          confirmPassword:
                                              viewModel.confirmPassword,
                                        ),
                                      );
                                    },
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
                                state.isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),

                          const SizedBox(height: 50),

                          // Login redirect text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Have an account? ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                },
                                child: const Text(
                                  "Log In!",
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
