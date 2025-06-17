import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String firstName;
  final String lastName;
  final String phone; // add phone
  final String? profileImage; // rename or add image as profileImage
  final String email;
  final String username;
  final String password;

  const UserEntity({
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone, // add here
    this.profileImage, // keep nullable
    required this.email,
    required this.username,
    required this.password, String? image,
  });

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    phone, // add here
    profileImage,
    email,
    username,
    password,
  ];
}
