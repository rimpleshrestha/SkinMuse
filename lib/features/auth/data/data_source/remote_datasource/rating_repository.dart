import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/api_config.dart';


class RatingRepository {
  late final Dio dio;

  RatingRepository._(this.dio);

  static Future<RatingRepository> create() async {
    final baseUrl = await ApiConfig.baseUrl;
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.options.headers['Content-Type'] = 'application/json';
    return RatingRepository._(dio);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<double> getUserRating() async {
    final token = await getToken();
    if (token == null) throw Exception("No token found");

    final response = await dio.get(
      '/user/rating',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (response.data['rating'] ?? 0).toDouble();
  }

  Future<void> saveUserRating(double rating) async {
    final token = await getToken();
    if (token == null) throw Exception("No token found");

    await dio.post(
      '/user/rating',
      data: {'rating': rating},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  void clearAuthHeader() {
    dio.options.headers.remove('Authorization');
  }
}
