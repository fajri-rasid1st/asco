// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/auth_data_source.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

abstract class AuthRepository {
  /// Login
  Future<Either<Failure, bool>> login(
    String username,
    String password,
  );

  /// Is login
  Future<Either<Failure, bool>> isLogin();

  /// Get credential
  Future<Either<Failure, Profile>> getCredential();

  /// Logout
  Future<Either<Failure, bool>> logOut();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  final NetworkInfo networkInfo;

  const AuthRepositoryImpl({
    required this.authDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> login(
    String username,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await authDataSource.login(username, password);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, bool>> isLogin() async {
    try {
      final result = await authDataSource.isLogin();

      return Right(result);
    } catch (e) {
      return Left(failure(e));
    }
  }

  @override
  Future<Either<Failure, Profile>> getCredential() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await authDataSource.getCredential();

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      final result = await authDataSource.logOut();

      return Right(result);
    } catch (e) {
      return Left(failure(e));
    }
  }
}
