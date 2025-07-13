class Validators {
  static bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$").hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidName(String name) {
    return name.trim().isNotEmpty;
  }

  static bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }
}
