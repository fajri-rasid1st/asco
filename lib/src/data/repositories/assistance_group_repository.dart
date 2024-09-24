// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/assistance_group_data_source.dart';
import 'package:asco/src/data/models/assistance_groups/assistance_group.dart';
import 'package:asco/src/data/models/assistance_groups/assistance_group_post.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

abstract class AssistanceGroupRepository {
  /// Admin: Get assistance groups
  Future<Either<Failure, List<AssistanceGroup>>> getAssistanceGroups(String practicumId);

  /// Admin: Get assistance group detail
  Future<Either<Failure, AssistanceGroup>> getAssistanceGroupDetail(String id);

  /// Admin: Create assistance group
  Future<Either<Failure, void>> createAssistanceGroup(
    String practicumId, {
    required AssistanceGroupPost assistanceGroup,
  });

  /// Admin: Edit assistance group
  Future<Either<Failure, void>> editAssistanceGroup(
    AssistanceGroup oldAssistanceGroup,
    AssistanceGroupPost newAssistanceGroup,
  );

  /// Admin: Delete assistance group
  Future<Either<Failure, void>> deleteAssistanceGroup(String id);

  /// Admin: Remove student from assistance group
  Future<Either<Failure, void>> removeStudentFromAssistanceGroup(
    String id, {
    required Profile student,
  });
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

  @override
  Future<Either<Failure, AssistanceGroup>> getAssistanceGroupDetail(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await assistanceGroupDataSource.getAssistanceGroupDetail(id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createAssistanceGroup(
    String practicumId, {
    required AssistanceGroupPost assistanceGroup,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await assistanceGroupDataSource.createAssistanceGroup(
          practicumId,
          assistanceGroup: assistanceGroup,
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
  Future<Either<Failure, void>> editAssistanceGroup(
    AssistanceGroup oldAssistanceGroup,
    AssistanceGroupPost newAssistanceGroup,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await assistanceGroupDataSource.editAssistanceGroup(
          oldAssistanceGroup,
          newAssistanceGroup,
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
  Future<Either<Failure, void>> deleteAssistanceGroup(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await assistanceGroupDataSource.deleteAssistanceGroup(id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> removeStudentFromAssistanceGroup(
    String id, {
    required Profile student,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await assistanceGroupDataSource.removeStudentFromAssistanceGroup(
          id,
          student: student,
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
