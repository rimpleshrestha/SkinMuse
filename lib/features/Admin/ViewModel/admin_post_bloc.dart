import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_muse/api_config.dart';

import 'admin_post_event.dart';
import 'admin_post_state.dart';

class AdminPostBloc extends Bloc<AdminPostEvent, AdminPostState> {
  AdminPostBloc() : super(const AdminPostState()) {
    on<FetchPosts>(_onFetchPosts);
    on<CreatePost>(_onCreatePost);
    on<UpdatePost>(_onUpdatePost);
    on<DeletePost>(_onDeletePost);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _onFetchPosts(
    FetchPosts event,
    Emitter<AdminPostState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Not authenticated");

      final baseUrl = await ApiConfig.baseUrl;
      final response = await http.get(
        Uri.parse("$baseUrl/post"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        emit(
          state.copyWith(
            posts: decoded['posts'] ?? [],
            isLoading: false,
            isSuccess: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Failed to fetch posts",
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onCreatePost(
    CreatePost event,
    Emitter<AdminPostState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Not authenticated");

      final baseUrl = await ApiConfig.baseUrl;
      final response = await http.post(
        Uri.parse("$baseUrl/post"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": event.title,
          "description": event.description,
          "skin_type": event.skinType,
          "image": event.image,
        }),
      );

      if (response.statusCode == 201) {
        add(FetchPosts()); // reload posts
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Failed to create post",
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdatePost(
    UpdatePost event,
    Emitter<AdminPostState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Not authenticated");

      final baseUrl = await ApiConfig.baseUrl;
      final response = await http.put(
        Uri.parse("$baseUrl/post/${event.postId}"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": event.title,
          "description": event.description,
          "skin_type": event.skinType,
          "image": event.image,
        }),
      );

      if (response.statusCode == 200) {
        add(FetchPosts());
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Failed to update post",
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeletePost(
    DeletePost event,
    Emitter<AdminPostState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Not authenticated");

      final baseUrl = await ApiConfig.baseUrl;
      final response = await http.delete(
        Uri.parse("$baseUrl/post/${event.postId}"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        add(FetchPosts());
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Failed to delete post",
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
