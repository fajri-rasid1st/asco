// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/assistance_group_data_source.dart';
import 'package:asco/src/data/models/assistance_groups/assistance_group.dart';

abstract class AssistanceGroupRepository {
  /// Get assistance groups
  Future<Either<Failure, List<AssistanceGroup>>> getAssistanceGroups(String practicumId);
}

class AssistanceGroupRepositoryImpl implements AssistanceGroupRepository {
  final AssistanceGroupDataSource assistanceGroupDataSource;
  final NetworkInfo networkInfo;

  const AssistanceGroupRepositoryImpl({
    required this.assistanceGroupDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AssistanceGroup>>> getAssistanceGroups(String practicumId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await assistanceGroupDataSource.getAssistanceGroups(practicumId);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
