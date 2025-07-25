import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/features/ProductList/presentation/view/product_list_screen.dart';
import 'package:skin_muse/features/auth/presentation/view/edit_profile_view.dart';


class ProfileView extends StatefulWidget {
  final String email;

  const ProfileView({super.key, required this.email});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String userName = "User";
  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('username');
    if (savedName != null && savedName.isNotEmpty) {
      setState(() {
        userName = savedName;
      });
    }
  }

  Future<void> _navigateToEditProfile() async {
    final updatedName = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileView()),
    );

    if (updatedName != null && updatedName.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', updatedName);
      setState(() {
        userName = updatedName;
      });
    }
  }

  void _handleLogout() async {
    setState(() {
      isLoggingOut = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoggingOut = false;
    });

    if (mounted) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icon.png', height: 120),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'assets/images/default_profile.png',
                ),
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
                        initialRating: 4,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30,
                        itemPadding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        itemBuilder:
                            (context, _) =>
                                const Icon(Icons.star, color: Colors.yellow),
                        onRatingUpdate: (rating) {
                          // you can handle rating update here
                        },
                      ),
                      const SizedBox(height: 30),
                      // ---- Updated "Your List" Row ----
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProductListScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: const [
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
                        onTap: _navigateToEditProfile,
                        child: Row(
                          children: const [
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
                onPressed: isLoggingOut ? null : _handleLogout,
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
                child:
                    isLoggingOut
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Logging out...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        )
                        : const Text(
                          "Logout",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
