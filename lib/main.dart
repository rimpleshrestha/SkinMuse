import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:skin_muse/features/admin/ViewModel/admin_post_bloc.dart';

import 'package:skin_muse/features/auth/data/data_source/remote_datasource/auth_remote_data_source.dart';
import 'package:skin_muse/features/auth/data/data_source/remote_datasource/rating_repository.dart';
import 'package:skin_muse/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:skin_muse/features/auth/presentation/bloc/editprofile/edit_profile_bloc.dart';

import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_cubit.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

import 'features/home/presentation/view/home_view.dart';
import 'features/splash/presentation/view/splash_view.dart';
import 'features/auth/presentation/view/register_view.dart';
import 'features/auth/presentation/view/login_view.dart';
import 'features/auth/presentation/view/edit_profile_view.dart';

// <-- Added import for AdminPostBloc

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Notifications
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserHiveModelAdapter());
  await Hive.openBox<UserHiveModel>('users');

  // Create RatingRepository asynchronously
  final ratingRepository = await RatingRepository.create();

  // Create AuthRemoteDataSource
  final authRemoteDataSource = AuthRemoteDataSource();

  // Create and load LoginCubit
  final loginCubit = LoginCubit(viewModel: LoginViewModel());
  await loginCubit.loadUserFromStorage();

  runApp(
    MyApp(
      loginCubit: loginCubit,
      authRemoteDataSource: authRemoteDataSource,
      ratingRepository: ratingRepository,
    ),
  );
}

class ProximityWrapper extends StatefulWidget {
  final Widget child;

  const ProximityWrapper({required this.child, Key? key}) : super(key: key);

  @override
  State<ProximityWrapper> createState() => _ProximityWrapperState();
}

class _ProximityWrapperState extends State<ProximityWrapper> {
  bool _isNear = false;
  late Stream<dynamic> _proximityStream;

  @override
  void initState() {
    super.initState();
    _proximityStream = ProximitySensor.events;
    _proximityStream.listen((event) {
      setState(() {
        _isNear = (event as int) > 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isNear)
          Container(
            color: Colors.black.withOpacity(0.7),
            alignment: Alignment.center,
            child: const Text(
              'Sensor triggered: phone is close',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  final LoginCubit loginCubit;
  final AuthRemoteDataSource authRemoteDataSource;
  final RatingRepository ratingRepository;

  const MyApp({
    Key? key,
    required this.loginCubit,
    required this.authRemoteDataSource,
    required this.ratingRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>.value(value: loginCubit),
        BlocProvider<ProfileBloc>(
          create:
              (_) => ProfileBloc(
                authRemoteDataSource: authRemoteDataSource,
                ratingRepository: ratingRepository,
              ),
        ),
        BlocProvider<EditProfileBloc>(
          create: (_) => EditProfileBloc(authRemoteDataSource),
        ),
        BlocProvider<AdminPostBloc>(
          // <-- Added AdminPostBloc here
          create: (_) => AdminPostBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashView(),
          '/register': (context) => const RegisterView(),
          '/login': (context) => const LoginView(),
          '/dashboard': (context) => const HomeView(),
          '/edit-profile': (context) => const EditProfileView(),
          // Add admin route here if you want:
          // '/admin': (context) => AdminPostView(userEmail: '', userId: ''),
        },
        builder: (context, child) {
          return ProximityWrapper(child: child ?? const SizedBox());
        },
      ),
    );
  }
}
