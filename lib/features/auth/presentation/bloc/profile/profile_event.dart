abstract class ProfileEvent {}

class UpdateName extends ProfileEvent {
  final String name;
  UpdateName(this.name);
}

class ChangePassword extends ProfileEvent {
  final String email;
  final String newPassword;
  final String confirmPassword;

  ChangePassword({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });
}

// 🔹 Existing Events for Rating
class LoadRating extends ProfileEvent {}

class UpdateRating extends ProfileEvent {
  final double rating;
  UpdateRating(this.rating);
}

// 🔹 New Event for fetching user profile (username, email, etc.)
class LoadUserProfile extends ProfileEvent {}
