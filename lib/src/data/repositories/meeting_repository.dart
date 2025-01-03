// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/meeting_data_source.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/meetings/meeting_post.dart';
import 'package:asco/src/data/models/meetings/meeting_schedule.dart';

abstract class MeetingRepository {
  /// Admin: Get meetings
  Future<Either<Failure, List<Meeting>>> getMeetings(
    String practicumId, {
    String query = '',
    bool asc = true,
  });

  /// Admin: Get meeting detail
  Future<Either<Failure, Meeting>> getMeetingDetail(String id);

  /// Admin: Create meeting
  Future<Either<Failure, void>> createMeeting(
    String practicumId, {
    required MeetingPost meeting,
  });

  /// Admin: Edit meeting
  Future<Either<Failure, void>> editMeeting(
    Meeting oldMeeting,
    MeetingPost newMeeting,
  );

  /// Admin: Delete meeting
  Future<Either<Failure, void>> deleteMeeting(String id);

  /// Student, Assistant: Get classroom meetings
  Future<Either<Failure, List<Meeting>>> getClassroomMeetings(
    String classroomId, {
    bool asc = true,
  });

  /// Assistant: Get meeting schedules
  Future<Either<Failure, List<MeetingSchedule>>> getMeetingSchedules({String practicum = ''});
}

class MeetingRepositoryImpl implements MeetingRepository {
  final MeetingDataSource meetingDataSource;
  final NetworkInfo networkInfo;

  const MeetingRepositoryImpl({
    required this.meetingDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Meeting>>> getMeetings(
    String practicumId, {
    String query = '',
    bool asc = true,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await meetingDataSource.getMeetings(
          practicumId,
          query: query,
          asc: asc,
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
  Future<Either<Failure, Meeting>> getMeetingDetail(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await meetingDataSource.getMeetingDetail(id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createMeeting(
    String practicumId, {
    required MeetingPost meeting,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await meetingDataSource.createMeeting(
          practicumId,
          meeting: meeting,
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
  Future<Either<Failure, void>> editMeeting(
    Meeting oldMeeting,
    MeetingPost newMeeting,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await meetingDataSource.editMeeting(oldMeeting, newMeeting);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMeeting(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await meetingDataSource.deleteMeeting(id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<Meeting>>> getClassroomMeetings(
    String classroomId, {
    bool asc = true,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await meetingDataSource.getClassroomMeetings(
          classroomId,
          asc: asc,
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
  Future<Either<Failure, List<MeetingSchedule>>> getMeetingSchedules({String practicum = ''}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await meetingDataSource.getMeetingSchedules(practicum: practicum);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
