import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class ApiConfig {
  static String? _baseUrl;

  /// Returns the backend base URL depending on platform and device type.
  ///
  /// - For physical Android/iOS devices: uses your PC local IP (update accordingly).
  /// - For emulators/simulators: uses localhost or 10.0.2.2.
  /// - For desktop/web defaults to localhost.
  static Future<String> get baseUrl async {
    if (_baseUrl != null) return _baseUrl!;

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.isPhysicalDevice) {
        // Physical Android phone → use PC IP (update this IP as per your network)
        _baseUrl = 'http://192.168.18.30:3000/api';
      } else {
        // Android emulator → use 10.0.2.2 to access host machine
        _baseUrl = 'http://10.0.2.2:3000/api';
      }
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice) {
        // Physical iPhone → use PC IP (update this IP as per your network)
        _baseUrl = 'http://192.168.18.30:3000/api';
      } else {
        // iOS simulator → use localhost
        _baseUrl = 'http://localhost:3000/api';
      }
    } else {
      // Default fallback (desktop/web)
      _baseUrl = 'http://localhost:3000/api';
    }

    return _baseUrl!;
  }
}
