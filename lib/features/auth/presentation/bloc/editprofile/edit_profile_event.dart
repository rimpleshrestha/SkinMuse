abstract class EditProfileEvent {}

class UpdateNamePressed extends EditProfileEvent {
  final String name;
  UpdateNamePressed(this.name);
}

class ChangePasswordPressed extends EditProfileEvent {
  final String currentPassword;
  final String newPassword;
  ChangePasswordPressed(this.currentPassword, this.newPassword);
}

class UpdateProfilePhotoPressed extends EditProfileEvent {
  final String imagePath;
  UpdateProfilePhotoPressed(this.imagePath);
}
