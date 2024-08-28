// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/classroom_data_source.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

abstract class ClassroomRepository {
  /// Get classrooms (authorized for student & assistant)
  Future<Either<Failure, List<Classroom>>> getUserClassrooms();

  /// Get classroom detail
  Future<Either<Failure, Classroom>> getClassroomDetail(String id);

  /// Add students to classroom
  Future<Either<Failure, void>> addStudentsToClassroom(
    String id, {
    required List<Profile> students,
  });

  /// Remove student from classroom
  Future<Either<Failure, void>> removeStudentFromClassroom(
    String id, {
    required Profile student,
  });
}

class ClassroomRepositoryImpl implements ClassroomRepository {
  final ClassroomDataSource classroomDataSource;
  final NetworkInfo networkInfo;

  const ClassroomRepositoryImpl({
    required this.classroomDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Classroom>>> getUserClassrooms() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await classroomDataSource.getUserClassrooms();

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, Classroom>> getClassroomDetail(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await classroomDataSource.getClassroomDetail(id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> addStudentsToClassroom(
    String id, {
    required List<Profile> students,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await classroomDataSource.addStudentsToClassroom(id, students: students);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> removeStudentFromClassroom(
    String id, {
    required Profile student,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await classroomDataSource.removeStudentFromClassroom(id, student: student);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
