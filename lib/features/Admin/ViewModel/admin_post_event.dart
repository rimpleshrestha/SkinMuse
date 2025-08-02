import 'package:equatable/equatable.dart';

abstract class AdminPostEvent extends Equatable {
  const AdminPostEvent();

  @override
  List<Object?> get props => [];
}

class FetchPosts extends AdminPostEvent {}

class CreatePost extends AdminPostEvent {
  final String title;
  final String description;
  final String skinType;
  final String image;

  const CreatePost({
    required this.title,
    required this.description,
    required this.skinType,
    required this.image,
  });

  @override
  List<Object?> get props => [title, description, skinType, image];
}

class UpdatePost extends AdminPostEvent {
  final String postId;
  final String title;
  final String description;
  final String skinType;
  final String image;

  const UpdatePost({
    required this.postId,
    required this.title,
    required this.description,
    required this.skinType,
    required this.image,
  });

  @override
  List<Object?> get props => [postId, title, description, skinType, image];
}

class DeletePost extends AdminPostEvent {
  final String postId;

  const DeletePost(this.postId);

  @override
  List<Object?> get props => [postId];
}
