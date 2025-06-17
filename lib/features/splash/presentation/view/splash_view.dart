import 'package:flutter/material.dart';
import 'package:skin_muse/features/splash/presentation/view_model/splash_view_model.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SplashViewModel _viewModel = SplashViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFFEDF5),
      body: Center(
        child: Image(image: AssetImage('assets/skinmuselogo.png'), width: 500),
      ),
    );
  }
}
