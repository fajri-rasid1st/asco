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

  /// Add meeting to practicum
  Future<Either<Failure, void>> addMeetingToPracticum(
    String practicumId, {
    required MeetingPost meeting,
  });
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
}
