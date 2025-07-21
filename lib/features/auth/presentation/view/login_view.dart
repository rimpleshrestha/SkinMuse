import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

import 'package:skin_muse/features/Admin/view/create_post_view.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_cubit.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:skin_muse/features/home/presentation/view/home_view.dart';
import 'package:skin_muse/features/home/presentation/view_model/home_view_model.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
                    listener: (context, state) {
                      if (state.status == LoginStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Successfully logged in"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        if ((state.user?.email ?? '') == 'admin@gmail.com') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreatePostView(),
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
                            ),
                            obscureText: true,
                            onChanged: viewModel.setPassword,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed:
                                state.status == LoginStatus.loading
                                    ? null
                                    : () async {
                                      await debugPrintUserId();
                                      cubit.login();
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

  Future<void> debugPrintUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final sharedId = prefs.getString('userId');
    final token = prefs.getString('accessToken');

    print("🔍 SharedPreferences:");
    print("➡️ accessToken: $token");
    print("➡️ userId: $sharedId");

    final box = await Hive.openBox<UserHiveModel>('userBox');
    final user = box.get('currentUser');

    print("🔍 Hive:");
    if (user != null) {
      print("➡️ userId: ${user.userId}");
      print("➡️ Full user object: $user");
    } else {
      print("⚠️ No user found in Hive under 'currentUser'");
    }
  }
}
