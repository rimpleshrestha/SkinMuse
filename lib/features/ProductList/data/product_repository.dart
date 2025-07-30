import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/api_config.dart';
import 'package:skin_muse/features/ProductList/data/model/product_model.dart';
 // Your ApiConfig

class ProductRepository {
  final Dio dio;

  ProductRepository._(this.dio);

  static Future<ProductRepository> create() async {
    final dio = Dio();
    final baseUrl = await ApiConfig.baseUrl;
    dio.options.baseUrl = baseUrl.replaceFirst(
      '/api',
      '',
    ); // remove trailing /api if needed
    dio.options.headers['Content-Type'] = 'application/json';
    return ProductRepository._(dio);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<List<ProductModel>> fetchSavedProducts() async {
    final token = await _getToken();
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.post('/api/post/saved');
    final data = response.data['savedPosts'] as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> saveProduct(String id) async {
    final token = await _getToken();
    dio.options.headers['Authorization'] = 'Bearer $token';

    await dio.post('/api/post/save/$id');
  }

  Future<void> unsaveProduct(String id) async {
    final token = await _getToken();
    dio.options.headers['Authorization'] = 'Bearer $token';

    await dio.delete('/api/post/unsave/$id');
  }
}
