import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skin_muse/app/use_case/use_case.dart';
import 'package:skin_muse/core/error/failure.dart';
import 'package:skin_muse/features/auth/domain/repository/user_repository.dart';


class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});

  const LoginParams.initial() : username = '', password = '';

  @override
  List<Object?> get props => [username, password];
}

class UserLoginUsecase implements UseCaseWithParams<String, LoginParams> {
  final IUserRepository _userRepository;

  UserLoginUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return await _userRepository.loginUser(params.username, params.password);
  }
}
