abstract class ProfileEvent {}

class UpdateName extends ProfileEvent {
  final String name;
  UpdateName(this.name);
}

class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  ChangePassword(this.currentPassword, this.newPassword);
}


