import 'package:equatable/equatable.dart';

class AdminPostState extends Equatable {
  final List<dynamic> posts;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const AdminPostState({
    this.posts = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  AdminPostState copyWith({
    List<dynamic>? posts,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AdminPostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [posts, isLoading, errorMessage, isSuccess];
}
