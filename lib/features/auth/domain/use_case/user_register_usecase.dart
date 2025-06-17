import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skin_muse/app/use_case/use_case.dart';
import 'package:skin_muse/core/error/failure.dart';
import 'package:skin_muse/features/auth/domain/entity/user_entity.dart';
import 'package:skin_muse/features/auth/domain/repository/user_repository.dart';





class RegisterUserParams extends Equatable {
  final String fname;
  final String lname;
  final String phone;
  final String username;
  final String password;
  final String? image;

  const RegisterUserParams({
    required this.fname,
    required this.lname,
    required this.phone,
    required this.username,
    required this.password,
    this.image,
  });

  const RegisterUserParams.initial()
    : fname = '',
      lname = '',
      phone = '',
      username = '',
      password = '',
      image = null;

  @override
  List<Object?> get props => [fname, lname, phone, username, password, image];
}

class UserRegisterUsecase
    implements UseCaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final userEntity = UserEntity(
      firstName: params.fname,
      lastName: params.lname,
      phone: params.phone,
      username: params.username,
      password: params.password,
      profileImage: params.image,  email: '',
    );
    return _userRepository.registerUser(userEntity);
  }
}
