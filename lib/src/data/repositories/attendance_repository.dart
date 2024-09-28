// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/attendance_data_source.dart';
import 'package:asco/src/data/models/attendances/attendance.dart';
import 'package:asco/src/data/models/attendances/attendance_meeting.dart';

abstract class AttendanceRepository {
  /// Student: Get attendances
  Future<Either<Failure, List<Attendance>>> getAttendances(String practicumId);

  /// Admin: Get attendance meetings
  Future<Either<Failure, List<AttendanceMeeting>>> getAttendanceMeetings(String practicumId);

  /// Admin: Get attendances by meeting id
  Future<Either<Failure, List<Attendance>>> getMeetingAttendances(
    String meetingId, {
    String classroom = '',
    String query = '',
  });

  /// Assistant: Insert all attendances in a meeting
  Future<Either<Failure, void>> insertMeetingAttendances(String meetingId);
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
  Future<Either<Failure, List<Attendance>>> getMeetingAttendances(
    String meetingId, {
    String classroom = '',
    String query = '',
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await attendanceDataSource.getMeetingAttendances(
          meetingId,
          classroom: classroom,
          query: query,
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
  Future<Either<Failure, void>> insertMeetingAttendances(String meetingId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await attendanceDataSource.insertMeetingAttendances(meetingId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
