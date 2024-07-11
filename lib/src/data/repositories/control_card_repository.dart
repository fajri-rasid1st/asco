// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/control_card_data_source.dart';
import 'package:asco/src/data/models/control_cards/control_card.dart';

abstract class ControlCardRepository {
  /// Get control cards
  Future<Either<Failure, List<ControlCard>>> getControlCards(String practicumId);
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
}
