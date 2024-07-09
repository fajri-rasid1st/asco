// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/repositories/file_repository.dart';
import 'package:asco/src/presentation/providers/datasource_providers/file_data_source_provider.dart';
import 'package:asco/src/presentation/providers/generated_providers/network_info_provider.dart';

part 'file_repository_provider.g.dart';

@riverpod
FileRepository fileRepository(FileRepositoryRef ref) {
  return FileRepositoryImpl(
    fileDataSource: ref.watch(fileDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
