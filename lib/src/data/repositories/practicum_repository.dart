// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/practicum_data_source.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/practicums/practicum_post.dart';

abstract class PracticumRepository {
  /// Get Practicums
  Future<Either<Failure, List<Practicum>>> getPracticums({String query = ''});

  /// Get practicum detail
  Future<Either<Failure, Practicum>> getPracticumDetail(String id);

  /// Create practicum
  Future<Either<Failure, String>> createPracticum(PracticumPost practicum);

  /// Edit practicum
  Future<Either<Failure, String>> editPracticum(String id, PracticumPost practicum);

  /// Delete practicum
  Future<Either<Failure, void>> deletePracticum(String id);
}

class PracticumRepositoryImpl implements PracticumRepository {
  final PracticumDataSource practicumDataSource;
  final NetworkInfo networkInfo;

  PracticumRepositoryImpl({
    required this.practicumDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Practicum>>> getPracticums({String query = ''}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await practicumDataSource.getPracticums(query: query);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, Practicum>> getPracticumDetail(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await practicumDataSource.getPracticumDetail(id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, String>> createPracticum(PracticumPost practicum) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await practicumDataSource.createPracticum(practicum);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, String>> editPracticum(String id, PracticumPost practicum) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await practicumDataSource.editPracticum(id, practicum);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> deletePracticum(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await practicumDataSource.deletePracticum(id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
