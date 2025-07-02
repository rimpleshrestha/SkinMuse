import 'package:skin_muse/core/network/api_service.dart';

class AuthRemoteDataSource {
  Future<String?> register(
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final res = await ApiService.dio.post(
        '/signup',
        data: {
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );
      return res.data['message'];
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final res = await ApiService.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      return res.data;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}
