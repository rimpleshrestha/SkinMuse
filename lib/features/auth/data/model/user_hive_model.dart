import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:skin_muse/app/constant/hive/hive_table_constant.dart';
import 'package:skin_muse/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String? profileImage;

  @HiveField(5)
  final String email;

  @HiveField(6)
  final String username;

  @HiveField(7)
  final String password;

  // ✅ NEW FIELD
  @HiveField(8)
  final String? name;

  UserHiveModel({
    String? userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.profileImage,
    required this.email,
    required this.username,
    required this.password,
    this.name, // ✅ Added
  }) : userId = userId ?? const Uuid().v4();

  // Initial empty constructor
  UserHiveModel.initial()
    : userId = '',
      firstName = '',
      lastName = '',
      phone = '',
      profileImage = '',
      email = '',
      username = '',
      password = '',
      name = '';

  // From Entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
      profileImage: entity.profileImage,
      email: entity.email,
      username: entity.username,
      password: entity.password,
      name: "${entity.firstName} ${entity.lastName}".trim(),
    );
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      profileImage: profileImage,
      email: email,
      username: username,
      password: password,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    phone,
    profileImage,
    email,
    username,
    password,
    name,
  ];
}
