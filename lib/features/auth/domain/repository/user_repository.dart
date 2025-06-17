import 'package:dartz/dartz.dart';
import 'package:skin_muse/core/error/failure.dart';
import 'package:skin_muse/features/auth/domain/entity/user_entity.dart';



abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);

  Future<Either<Failure, String>> loginUser(String username, String password);
}
