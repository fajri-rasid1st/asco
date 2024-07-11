// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/profile_data_source.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/data/models/profiles/profile_post.dart';

abstract class ProfileRepository {
  /// Get Profiles
  Future<Either<Failure, List<Profile>>> getProfiles({
    String query = '',
    String role = '',
    String sortBy = '',
    String orderBy = '',
  });

  /// Get profile detail
  Future<Either<Failure, Profile>> getProfileDetail(String id);

  /// Create profiles
  Future<Either<Failure, void>> createProfiles(List<ProfilePost> profiles);

  /// Edit profile
  Future<Either<Failure, void>> editProfile(String username, ProfilePost profile);

  /// Delete profile
  Future<Either<Failure, void>> deleteProfile(String username);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource profileDataSource;
  final NetworkInfo networkInfo;

  const ProfileRepositoryImpl({
    required this.profileDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Profile>>> getProfiles({
    String query = '',
    String role = '',
    String sortBy = '',
    String orderBy = '',
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await profileDataSource.getProfiles(
          query: query,
          role: role,
          sortBy: sortBy,
          orderBy: orderBy,
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
  Future<Either<Failure, Profile>> getProfileDetail(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await profileDataSource.getProfileDetail(id);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> createProfiles(List<ProfilePost> profiles) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await profileDataSource.createProfiles(profiles);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> editProfile(String username, ProfilePost profile) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await profileDataSource.editProfile(username, profile);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile(String username) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await profileDataSource.deleteProfile(username);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
