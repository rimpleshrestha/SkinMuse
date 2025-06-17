import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skin_muse/core/error/failure.dart';
import 'package:skin_muse/features/auth/data/data_source/user_data_source.dart'; // Import interface here
import 'package:skin_muse/features/auth/domain/entity/user_entity.dart';
import 'package:skin_muse/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final IUserDataSource _userLocalDatasource;

  UserLocalRepository({required IUserDataSource userLocalDatasource})
    : _userLocalDatasource = userLocalDatasource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> loginUser(
    String username,
    String password,
  ) async {
    try {
      final result = await _userLocalDatasource.loginUser(username, password);
      return Right(result);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Failed to login: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDatasource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Failed to register: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) {
    throw UnimplementedError();
  }
}
