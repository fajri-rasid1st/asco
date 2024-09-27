// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/enums/model_attributes.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/score_data_source.dart';
import 'package:asco/src/data/models/scores/score_recap.dart';

abstract class ScoreRepository {
  /// Admin, Assistant, Student: Get scores
  Future<Either<Failure, List<ScoreRecap>>> getScores(
    String practicumId, {
    String query = '',
    ScoreAttribute sortedBy = ScoreAttribute.username,
    bool asc = true,
  });

  /// Admin, Assistant: Get student score detail
  Future<Either<Failure, ScoreRecap>> getStudentScoreDetail(
    String practicumId,
    String username,
  );

  /// Student: Get score detail
  Future<Either<Failure, ScoreRecap>> getScoreDetail(String practicumId);
}

class ScoreRepositoryImpl implements ScoreRepository {
  final ScoreDataSource scoreDataSource;
  final NetworkInfo networkInfo;

  const ScoreRepositoryImpl({
    required this.scoreDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ScoreRecap>>> getScores(
    String practicumId, {
    String query = '',
    ScoreAttribute sortedBy = ScoreAttribute.username,
    bool asc = true,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await scoreDataSource.getScores(
          practicumId,
          query: query,
          sortedBy: sortedBy,
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
  Future<Either<Failure, ScoreRecap>> getStudentScoreDetail(
    String practicumId,
    String username,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await scoreDataSource.getStudentScoreDetail(practicumId, username);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, ScoreRecap>> getScoreDetail(String practicumId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await scoreDataSource.getScoreDetail(practicumId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
