import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/core/network/api_service.dart';

class AuthRemoteDataSource {
  // Helper to get saved token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

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

  Future<String?> updateName(String name) async {
    try {
      final token = await _getToken();
      if (token != null) {
        ApiService.dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final res = await ApiService.dio.put(
        '/update-details',
        data: {'name': name},
      );
      return res.data['message'];
    } catch (e) {
      print('Update name error: $e');
      return null;
    }
  }

  // ✅ FIXED: Use new + confirm password as required by backend
Future<String?> changePassword(
    String email,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final token = await _getToken();
      if (token != null) {
        ApiService.dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final res = await ApiService.dio.put(
        '/change-password',
        data: {
          'email': email,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );
      return res.data['message'];
    } catch (e) {
      print('Change password error: $e');
      return null;
    }
  }




  Future<String?> uploadProfilePhoto(File file) async {
    try {
      final token = await _getToken();
      if (token != null) {
        ApiService.dio.options.headers['Authorization'] = 'Bearer $token';
      }

      FormData formData = FormData.fromMap({
        'pfp': await MultipartFile.fromFile(file.path),
      });

      final res = await ApiService.dio.put(
        '/update-profile-image',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return res.data['message'];
    } catch (e) {
      print('Photo upload error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final token = await _getToken();
      if (token != null) {
        ApiService.dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final res = await ApiService.dio.get('/me');
      return res.data['user'];
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }
}
