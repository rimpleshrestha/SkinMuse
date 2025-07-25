abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String userName;
  ProfileLoaded(this.userName);
}

class ProfileSuccess extends ProfileState {
  final String message;
  ProfileSuccess(this.message);
}

class ProfileFailure extends ProfileState {
  final String error;
  ProfileFailure(this.error);
}

// 🔹 Rating States
class RatingLoading extends ProfileState {}

class RatingLoaded extends ProfileState {
  final double rating;
  RatingLoaded(this.rating);
}

class RatingUpdated extends ProfileState {
  final double rating;
  RatingUpdated(this.rating);
}
