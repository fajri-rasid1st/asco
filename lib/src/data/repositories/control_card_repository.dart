// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/control_card_data_source.dart';
import 'package:asco/src/data/models/assistances/assistance_post.dart';
import 'package:asco/src/data/models/control_cards/control_card.dart';

abstract class ControlCardRepository {
  /// Student: Get control cards
  Future<Either<Failure, List<ControlCard>>> getControlCards(String practicumId);

  /// Admin, Assistant, Student: Get student control cards
  Future<Either<Failure, List<ControlCard>>> getStudentControlCards(
    String practicumId,
    String studentId,
  );

  /// Student: Get control card detail
  Future<Either<Failure, ControlCard>> getControlCardDetail(String id);

  /// Assistant: Get assistance group meeting control cards
  Future<Either<Failure, List<ControlCard>>> getMeetingControlCards(String meetingId);

  /// Assistant: Update student assistance
  Future<Either<Failure, void>> updateAssistance(
    String assistanceId,
    AssistancePost assistance,
  );
}

class ControlCardRepositoryImpl implements ControlCardRepository {
  final ControlCardDataSource controlCardDataSource;
  final NetworkInfo networkInfo;

  const ControlCardRepositoryImpl({
    required this.controlCardDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ControlCard>>> getControlCards(String practicumId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await controlCardDataSource.getControlCards(practicumId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<ControlCard>>> getStudentControlCards(
    String practicumId,
    String studentId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await controlCardDataSource.getStudentControlCards(practicumId, studentId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, ControlCard>> getControlCardDetail(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await controlCardDataSource.getControlCardDetail(id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<ControlCard>>> getMeetingControlCards(String meetingId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await controlCardDataSource.getMeetingControlCards(meetingId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> updateAssistance(
    String assistanceId,
    AssistancePost assistance,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await controlCardDataSource.updateAssistance(assistanceId, assistance);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
