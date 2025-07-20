import 'package:skin_muse/core/network/api_service.dart';

class ProductRemoteDataSource {
  Future<List<dynamic>> getProductsBySkinType(String skinType) async {
    try {
      String url = '/post';
      if (skinType != 'all') {
        url += '?type=$skinType';
      }
      final res = await ApiService.dio.get(url);
      return res.data['posts'] ?? [];
    } catch (e) {
      throw Exception('Failed to fetch products');
    }
  }
}
