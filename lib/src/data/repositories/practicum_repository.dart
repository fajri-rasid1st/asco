// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/practicum_data_source.dart';
import 'package:asco/src/data/models/classrooms/classroom_post.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/practicums/practicum_post.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

abstract class PracticumRepository {
  /// Get Practicums
  Future<Either<Failure, List<Practicum>>> getPracticums();

  /// Get practicum detail
  Future<Either<Failure, Practicum>> getPracticumDetail(String id);

  /// Create practicum
  Future<Either<Failure, String>> createPracticum(PracticumPost practicum);

  /// Edit practicum
  Future<Either<Failure, String>> editPracticum(String id, PracticumPost practicum);

  /// Delete practicum
  Future<Either<Failure, void>> deletePracticum(String id);

  /// Add classrooms and assistants to practicum
  Future<Either<Failure, void>> addClassroomsAndAssistantsToPracticum(
    String id, {
    required List<ClassroomPost> classrooms,
    required List<Profile> assistants,
  });
}

class PracticumRepositoryImpl implements PracticumRepository {
  final PracticumDataSource practicumDataSource;
  final NetworkInfo networkInfo;

  PracticumRepositoryImpl({
    required this.practicumDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Practicum>>> getPracticums() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await practicumDataSource.getPracticums();

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

  @override
  Future<Either<Failure, void>> addClassroomsAndAssistantsToPracticum(
    String id, {
    required List<ClassroomPost> classrooms,
    required List<Profile> assistants,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await practicumDataSource.addClassroomsAndAssistantsToPracticum(
          id,
          classrooms: classrooms,
          assistants: assistants,
        );

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
