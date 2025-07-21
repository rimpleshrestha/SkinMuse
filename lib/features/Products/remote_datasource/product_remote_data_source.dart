import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/core/network/api_service.dart';

import 'package:skin_muse/features/Products/product_viewmodel/product_model.dart'; // Add this import

class ProductRemoteDataSource {
  Future<List<Product>> getProductsBySkinType(String skinType) async {
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

      final List posts = res.data['posts'] ?? [];
      return posts.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products');
    }
  }
}
