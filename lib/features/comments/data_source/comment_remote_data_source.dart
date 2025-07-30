import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/api_config.dart';
// import your ApiConfig here

class CommentRemoteDataSource {
  late final Dio dio;

  CommentRemoteDataSource._(this.dio);

  static Future<CommentRemoteDataSource> create() async {
    final baseUrl = await ApiConfig.baseUrl;
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.options.headers['Content-Type'] = 'application/json';
    return CommentRemoteDataSource._(dio);
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null || token.isEmpty) {
      throw Exception('No access token found');
    }
    return token;
  }

  Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
    final token = await _getToken();

    final response = await dio.get(
      '/comments/post/$postId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> postComment(
    String postId,
    String comment,
  ) async {
    final token = await _getToken();

    final response = await dio.post(
      '/comments/$postId',
      data: {'comment': comment},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }

  Future<void> deleteComment(String commentId) async {
    final token = await _getToken();

    await dio.delete(
      '/comments/$commentId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<Map<String, dynamic>> updateComment(
    String commentId,
    String comment,
  ) async {
    final token = await _getToken();

    final response = await dio.put(
      '/comments/$commentId',
      data: {'comment': comment},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }
}
