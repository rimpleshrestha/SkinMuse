abstract class EditProfileEvent {}

class UpdateNamePressed extends EditProfileEvent {
  final String name;
  UpdateNamePressed(this.name);
}

class ChangePasswordPressed extends EditProfileEvent {
  final String email;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordPressed(this.email, this.newPassword, this.confirmPassword);
}


class UpdateProfilePhotoPressed extends EditProfileEvent {
  final String imagePath;
  UpdateProfilePhotoPressed(this.imagePath);
}
