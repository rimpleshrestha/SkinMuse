import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/api_config.dart';


class ApiService {
  static Dio? _dio;

  /// Get singleton Dio instance with dynamic baseUrl and interceptor for token
  static Future<Dio> getDio() async {
    if (_dio != null) return _dio!;

    final baseUrl = await ApiConfig.baseUrl;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('accessToken');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    return _dio!;
  }

  /// Example: register user
  static Future<bool> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final dio = await getDio();

      final response = await dio.post(
        '/signup',
        data: {
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Add other static API methods here, or just get Dio and use it in repositories.
}
