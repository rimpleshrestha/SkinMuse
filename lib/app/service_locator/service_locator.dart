import 'package:get_it/get_it.dart';
import 'package:skin_muse/core/network/hive_service.dart';
import 'package:skin_muse/features/auth/data/data_source/local_datasource/user_local_data_source.dart';
import 'package:skin_muse/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:skin_muse/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHive();
  _initAuthModule();
}

Future<void> _initHive() async {
  final hiveService = HiveService();
  await hiveService.init();
  serviceLocator.registerSingleton<HiveService>(hiveService);
}

void _initAuthModule() {
  // Register UserLocalDatasource with HiveService dependency
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveService: serviceLocator()),
  );

  // Register ViewModels without any constructor parameters
  serviceLocator.registerFactory(() => LoginViewModel());
  serviceLocator.registerFactory(() => RegisterViewModel());
}
