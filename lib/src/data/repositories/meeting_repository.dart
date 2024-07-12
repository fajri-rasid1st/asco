// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/meeting_data_source.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/meetings/meeting_post.dart';

abstract class MeetingRepository {
  /// Get meetings
  Future<Either<Failure, List<Meeting>>> getMeetings(String practicumId);

  /// Get meeting detail
  Future<Either<Failure, Meeting>> getMeetingDetail(String id);

  /// Add meeting to practicum
  Future<Either<Failure, void>> addMeetingToPracticum(
    String practicumId, {
    required MeetingPost meeting,
  });

  /// Edit meeting
  Future<Either<Failure, void>> editMeeting(Meeting oldMeeting, MeetingPost newMeeting);

  /// Delete meeting
  Future<Either<Failure, void>> deleteMeeting(String id);
}

class MeetingRepositoryImpl implements MeetingRepository {
  final MeetingDataSource meetingDataSource;
  final NetworkInfo networkInfo;

  const MeetingRepositoryImpl({
    required this.meetingDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Meeting>>> getMeetings(String practicumId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await meetingDataSource.getMeetings(practicumId);

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
  Future<Either<Failure, void>> addMeetingToPracticum(
    String practicumId, {
    required MeetingPost meeting,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await meetingDataSource.addMeetingToPracticum(
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
  Future<Either<Failure, void>> editMeeting(Meeting oldMeeting, MeetingPost newMeeting) async {
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
}
