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
  /// Get attendances (authorized for student)
  Future<Either<Failure, List<Attendance>>> getAttendances(String practicumId);

  /// Get attendance meetings (authorized for admin)
  Future<Either<Failure, List<AttendanceMeeting>>> getAttendanceMeetings(String practicumId);

  /// Get attendances by meeting id (authorized for admin)
  Future<Either<Failure, List<Attendance>>> getMeetingAttendances(String meetingId);

  /// Insert all attendances in a meeting (authorized for assistant)
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
  Future<Either<Failure, List<Attendance>>> getAttendances(String practicumId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await attendanceDataSource.getAttendances(practicumId);

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
  Future<Either<Failure, List<Attendance>>> getMeetingAttendances(String meetingId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await attendanceDataSource.getMeetingAttendances(meetingId);

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
