import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skin_muse/features/auth/data/model/user_hive_model.dart';

class HiveService {
  static const String userBox = 'userBox';

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);

    // Register the generated adapter for UserHiveModel
    if (!Hive.isAdapterRegistered(UserHiveModelAdapter().typeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }

    // Open the box for UserHiveModel
    await Hive.openBox<UserHiveModel>(userBox);
  }

  Future<void> saveUser(UserHiveModel user) async {
    final box = Hive.box<UserHiveModel>(userBox);
    await box.put(user.userId, user);
  }

  UserHiveModel? getUser(String userId) {
    final box = Hive.box<UserHiveModel>(userBox);
    return box.get(userId);
  }

  Future<UserHiveModel?> login(String username, String password) async {
    final box = Hive.box<UserHiveModel>(userBox);
    try {
      return box.values.firstWhere(
        (user) => user.username == username && user.password == password,
        orElse: () => throw StateError('No matching user'),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteUser(String userId) async {
    final box = Hive.box<UserHiveModel>(userBox);
    await box.delete(userId);
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(userBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
