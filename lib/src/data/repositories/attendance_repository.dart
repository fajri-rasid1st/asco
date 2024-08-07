// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/attendance_data_source.dart';
import 'package:asco/src/data/models/attendances/attendance.dart';
import 'package:asco/src/data/models/attendances/attendance_meeting.dart';
import 'package:asco/src/data/models/attendances/attendance_post.dart';

abstract class AttendanceRepository {
  /// Get attendances (student)
  Future<Either<Failure, List<Attendance>>> getStudentAttendances(String practicumId);

  /// Get attendance meetings
  Future<Either<Failure, List<AttendanceMeeting>>> getAttendanceMeetings(String practicumId);

  /// Get attendances by meeting
  Future<Either<Failure, List<Attendance>>> getAttendances(String meetingId);

  /// Create attendance by meeting
  Future<Either<Failure, void>> createAttendance(
    String meetingId, {
    required AttendancePost attendance,
  });
}

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceDataSource attendanceDataSource;
  final NetworkInfo networkInfo;

  const AttendanceRepositoryImpl({
    required this.attendanceDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Attendance>>> getStudentAttendances(String practicumId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await attendanceDataSource.getStudentAttendances(practicumId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceMeeting>>> getAttendanceMeetings(String practicumId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await attendanceDataSource.getAttendanceMeetings(practicumId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getAttendances(String meetingId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await attendanceDataSource.getAttendances(meetingId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createAttendance(
    String meetingId, {
    required AttendancePost attendance,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await attendanceDataSource.createAttendance(
          meetingId,
          attendance: attendance,
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
