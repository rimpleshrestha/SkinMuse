abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final String message;
  ProfileSuccess(this.message);
}

class ProfileFailure extends ProfileState {
  final String error;
  ProfileFailure(this.error); // <-- remove const here
}
