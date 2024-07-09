// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:asco/core/connections/network_info.dart';
import 'package:asco/core/errors/failures.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/data/datasources/file_data_source.dart';

abstract class FileRepository {
  /// Upload any file
  Future<Either<Failure, String>> uploadAnyFile(String path);
}

class FileRepositoryImpl implements FileRepository {
  final FileDataSource fileDataSource;
  final NetworkInfo networkInfo;

  FileRepositoryImpl({
    required this.fileDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> uploadAnyFile(String path) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await fileDataSource.uploadAnyFile(path);

        return Right(result);
      } catch (e) {
        return Left(failure(e));
      }
    } else {
      return const Left(ConnectionFailure(kNoInternetConnection));
    }
  }
}
