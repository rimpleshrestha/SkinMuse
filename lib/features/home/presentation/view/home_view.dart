import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_muse/features/Products/view/product_view.dart';
import 'package:skin_muse/features/auth/presentation/view/profile_view.dart';
import 'package:skin_muse/features/home/presentation/view_model/home_view_model.dart';
import 'package:skin_muse/features/quiz/presentation/view/quiz_screen.dart';
 // <-- import your product view here

class HomeView extends StatelessWidget {
  final String email;

  const HomeView({super.key, this.email = ''});

  // List of pages
  List<Widget> _pages(BuildContext context, String email) => [
    _buildWelcomeScreen(context),
    ProductView(skinType: '',), // your product screen here
    ProfileView(email: email),
  ];

  Widget _buildWelcomeScreen(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFAD1E3), Color(0xFFFF65AA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/skinmuse_image.png', width: 180, height: 180),
            const SizedBox(height: 16),
            const Text(
              'Welcome to SkinMuse!',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Inter_Bold',
                color: Color(0xFFA55166),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '500 users satisfied, are you next?',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA55166),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Take Quiz',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Inter_Bold',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, int>(
      builder: (context, selectedIndex) {
        final pages = _pages(context, email);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFFAD1E3),
            elevation: 0,
            title: Row(children: [Image.asset('assets/icon.png', height: 80)]),
          ),
          body: pages[selectedIndex],
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home,
                    label: 'Home',
                    selected: selectedIndex == 0,
                    onTap: () => context.read<HomeViewModel>().setIndex(0),
                  ),
                  _NavItem(
                    icon: Icons.list_alt,
                    label: 'Products', // renamed label here
                    selected: selectedIndex == 1,
                    onTap: () => context.read<HomeViewModel>().setIndex(1),
                  ),
                  _NavItem(
                    icon: Icons.person,
                    label: 'Profile',
                    selected: selectedIndex == 2,
                    onTap: () => context.read<HomeViewModel>().setIndex(2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFFA55166);
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? activeColor : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? activeColor : Colors.grey,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
