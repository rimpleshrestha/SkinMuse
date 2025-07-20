import 'package:skin_muse/features/Products/remote_datasource/product_remote_data_source.dart';



class ProductViewModel {
  final ProductRemoteDataSource remoteDataSource;

  ProductViewModel({required this.remoteDataSource});

  Future<List<dynamic>> fetchProductsBySkinType(String skinType) {
    return remoteDataSource.getProductsBySkinType(skinType);
  }
}
