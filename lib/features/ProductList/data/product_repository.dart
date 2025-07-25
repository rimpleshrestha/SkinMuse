import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/features/ProductList/data/model/product_model.dart';

class ProductRepository {
  final Dio dio;

  ProductRepository(this.dio) {
    dio.options.baseUrl = "http://10.0.2.2:3000"; // Android emulator localhost
    dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<List<ProductModel>> fetchSavedProducts() async {
    final token = await _getToken();
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.post('/api/post/saved'); // <-- fixed endpoint
    final data = response.data['savedPosts'] as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> saveProduct(String id) async {
    final token = await _getToken();
    dio.options.headers['Authorization'] = 'Bearer $token';

    await dio.post('/api/post/save/$id'); // <-- fixed endpoint
  }

  Future<void> unsaveProduct(String id) async {
    final token = await _getToken();
    dio.options.headers['Authorization'] = 'Bearer $token';

    await dio.delete('/api/post/unsave/$id'); // <-- fixed endpoint
  }
}
