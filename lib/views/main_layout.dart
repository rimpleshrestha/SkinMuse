// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:skin_muse/features/home/presentation/view_model/home_view_model.dart';

// class MainLayout extends StatelessWidget {
//   final Widget child;
//   final String email;

//   const MainLayout({super.key, required this.child, this.email = ''});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeViewModel, int>(
//       builder: (context, selectedIndex) {
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: const Color(0xFFFAD1E3),
//             elevation: 0,
//             title: Row(children: [Image.asset('assets/icon.png', height: 80)]),
//           ),
//           body: child,
//           bottomNavigationBar: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//             child: Container(
//               height: 70,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 6,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _NavItem(
//                     icon: Icons.home,
//                     label: 'Home',
//                     selected: selectedIndex == 0,
//                     onTap: () => context.read<HomeViewModel>().setIndex(0),
//                   ),
//                   _NavItem(
//                     icon: Icons.list_alt,
//                     label: 'Products',
//                     selected: selectedIndex == 1,
//                     onTap: () => context.read<HomeViewModel>().setIndex(1),
//                   ),
//                   _NavItem(
//                     icon: Icons.person,
//                     label: 'Profile',
//                     selected: selectedIndex == 2,
//                     onTap: () => context.read<HomeViewModel>().setIndex(2),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
