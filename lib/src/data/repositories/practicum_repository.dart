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

abstract class PracticumRepository {
  /// Admin, Assistant: Get Practicums
  Future<Either<Failure, List<Practicum>>> getPracticums();

  /// Admin: Get practicum detail
  Future<Either<Failure, Practicum>> getPracticumDetail(String id);

  /// Admin: Create practicum
  Future<Either<Failure, String>> createPracticum(PracticumPost practicum);

  /// Admin: Edit practicum
  Future<Either<Failure, String>> editPracticum(
    Practicum oldPracticum,
    PracticumPost newPracticum,
  );

  /// Admin: Delete practicum
  Future<Either<Failure, void>> deletePracticum(String id);

  /// Admin: Create classrooms and assistants
  Future<Either<Failure, void>> createClassroomsAndAssistants(
    String id, {
    required List<ClassroomPost> classrooms,
    required List<String> assistants,
  });

  /// Admin: Remove classroom from practicum
  Future<Either<Failure, void>> removeClassroomFromPracticum(String classroomId);

  /// Admin: Remove assistant from practicum
  Future<Either<Failure, void>> removeAssistantFromPracticum(
    String id, {
    required String username,
  });
}

class PracticumRepositoryImpl implements PracticumRepository {
  final PracticumDataSource practicumDataSource;
  final NetworkInfo networkInfo;

  const PracticumRepositoryImpl({
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
  Future<Either<Failure, String>> editPracticum(
    Practicum oldPracticum,
    PracticumPost newPracticum,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await practicumDataSource.editPracticum(oldPracticum, newPracticum);

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
  Future<Either<Failure, void>> createClassroomsAndAssistants(
    String id, {
    required List<ClassroomPost> classrooms,
    required List<String> assistants,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await practicumDataSource.createClassroomsAndAssistants(
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

  @override
  Future<Either<Failure, void>> removeClassroomFromPracticum(String classroomId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await practicumDataSource.removeClassroomFromPracticum(classroomId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> removeAssistantFromPracticum(
    String id, {
    required String username,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await practicumDataSource.removeAssistantFromPracticum(
          id,
          username: username,
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
