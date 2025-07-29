import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class ApiConfig {
  static String? _baseUrl;

  static Future<String> get baseUrl async {
    if (_baseUrl != null) return _baseUrl!;

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.isPhysicalDevice) {
        _baseUrl =
            'http://192.168.1.100:3000'; // <-- REPLACE with your PC LAN IP
      } else {
        _baseUrl = 'http://10.0.2.2:3000'; // Android emulator localhost
      }
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice) {
        _baseUrl =
            'http://192.168.1.100:3000'; // <-- REPLACE with your PC LAN IP
      } else {
        _baseUrl = 'http://localhost:3000'; // iOS simulator localhost
      }
    } else {
      _baseUrl = 'http://localhost:3000'; // fallback
    }

    return _baseUrl!;
  }
}
