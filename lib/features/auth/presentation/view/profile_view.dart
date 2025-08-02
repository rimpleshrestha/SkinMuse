import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/features/ProductList/presentation/view/product_list_screen.dart';
import 'package:skin_muse/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:skin_muse/features/auth/presentation/bloc/profile/profile_event.dart';
import 'package:skin_muse/features/auth/presentation/bloc/profile/profile_state.dart';
import 'package:skin_muse/features/auth/presentation/view/edit_profile_view.dart';
import 'package:hive/hive.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';

class ProfileView extends StatefulWidget {
  final String email;
  const ProfileView({super.key, required this.email});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String cachedName = "User";

  @override
  void initState() {
    super.initState();
    _loadCachedName();
    context.read<ProfileBloc>().add(LoadUserProfile()); // fetch user name
    context.read<ProfileBloc>().add(LoadRating()); // fetch rating
  }

  Future<void> _loadCachedName() async {
    final box = Hive.box<UserHiveModel>('users');
    if (box.isNotEmpty) {
      final user = box.getAt(0);
      if (user?.name != null && user!.name!.isNotEmpty) {
        setState(() => cachedName = user.name!);
      }
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    debugPrint("🔒 User logged out, shared prefs cleared");

    if (mounted) {
      Navigator.of(context).pop(); // remove dialog
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFFFFF0F5);
    final pinkColor = const Color(0xFFE91E63);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is ProfileSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            double userRating = 0.0;
            String userName = cachedName; // fallback name

            if (state is RatingLoaded) {
              userRating = state.rating;
            }
            if (state is ProfileLoaded) {
              userName = state.userName;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Just the image shown normally, no circle or decoration
                  Image.asset(
                    'assets/icon.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.email, color: pinkColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.email,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: pinkColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            "Rate the App",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          RatingBar.builder(
                            initialRating: userRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30,
                            itemBuilder:
                                (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                            onRatingUpdate: (rating) {
                              context.read<ProfileBloc>().add(
                                UpdateRating(rating),
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ProductListScreen(),
                                  ),
                                ),
                            child: const Row(
                              children: [
                                Icon(Icons.list, color: Colors.pinkAccent),
                                SizedBox(width: 10),
                                Text(
                                  "Your List",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EditProfileView(),
                                  ),
                                ),
                            child: const Row(
                              children: [
                                Icon(Icons.update, color: Colors.pinkAccent),
                                SizedBox(width: 10),
                                Text(
                                  "Update Profile",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => _handleLogout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA55166),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
