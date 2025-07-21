import 'package:dio/dio.dart';
import 'package:skin_muse/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRemoteDataSource {
  Future<List<dynamic>> getProductsBySkinType(String skinType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      String url = '/post';
      if (skinType != 'all') {
        url += '?type=$skinType';
      }

      final res = await ApiService.dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return res.data['posts'] ?? [];
    } catch (e) {
      throw Exception('Failed to fetch products');
    }
  }
}
