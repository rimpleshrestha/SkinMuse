// import 'package:equatable/equatable.dart';
// import 'package:skin_muse/features/ad/domain/entities/post_entity.dart';

// abstract class CreatePostEvent extends Equatable {
//   const CreatePostEvent();

//   @override
//   List<Object?> get props => [];
// }

// class CreatePostSubmitted extends CreatePostEvent {
//   final PostEntity post;
//   final String token;

//   const CreatePostSubmitted(this.post, this.token);

//   @override
//   List<Object?> get props => [post, token];
// }

// class UpdatePostSubmitted extends CreatePostEvent {
//   final PostEntity post;
//   final String token;
//   final bool forceEdit; // <-- Added

//   const UpdatePostSubmitted(this.post, this.token, {this.forceEdit = false});

//   @override
//   List<Object?> get props => [post, token, forceEdit];
// }
