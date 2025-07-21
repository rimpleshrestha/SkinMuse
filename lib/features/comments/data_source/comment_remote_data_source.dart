import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentRemoteDataSource {
  final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000/api'));

  // Fetch all comments for a specific post
  Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    final response = await dio.get(
      '/comments/post/$postId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return List<Map<String, dynamic>>.from(response.data);
  }

  // Post a new comment
  Future<Map<String, dynamic>> postComment(
    String postId,
    String comment,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    final response = await dio.post(
      '/comments/$postId',
      data: {'comment': comment},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }

  // Delete an existing comment
  Future<void> deleteComment(String commentId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    await dio.delete(
      '/comments/$commentId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // Update/edit a comment
  Future<Map<String, dynamic>> updateComment(
    String commentId,
    String comment,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    final response = await dio.put(
      '/comments/$commentId',
      data: {'comment': comment},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }
}
