abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final String message;
  EditProfileSuccess(this.message);
}

class EditProfileFailure extends EditProfileState {
  final String error;
  EditProfileFailure(this.error);
}
