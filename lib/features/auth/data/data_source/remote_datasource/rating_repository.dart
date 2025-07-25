import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingRepository {
  final Dio dio;

  RatingRepository(this.dio) {
    dio.options.baseUrl = "http://10.0.2.2:3000/api";
  }

  /// 🔹 Helper to get token for current user
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  /// 🔹 Get rating for logged-in user (based on token)
  Future<double> getUserRating() async {
    final token = await getToken();
    if (token == null) throw Exception("No token found");

    dio.options.headers['Authorization'] = 'Bearer $token';
    final response = await dio.get('/user/rating');
    return (response.data['rating'] ?? 0).toDouble();
  }

  /// 🔹 Save rating for logged-in user (based on token)
  Future<void> saveUserRating(double rating) async {
    final token = await getToken();
    if (token == null) throw Exception("No token found");

    dio.options.headers['Authorization'] = 'Bearer $token';
    await dio.post('/user/rating', data: {'rating': rating});
  }

  /// 🔹 Clear header when user logs out
  void clearAuthHeader() {
    dio.options.headers.remove('Authorization');
  }
}
