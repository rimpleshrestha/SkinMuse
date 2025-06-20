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
                      if (viewModel.password != viewModel.confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Passwords should match"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } else if (state.isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Successfully registered"),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    builder: (context, state) {
                      final bloc = context.read<RegisterBloc>();

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/skinmuselogo.png', height: 300),
                          const SizedBox(height: 24),
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
