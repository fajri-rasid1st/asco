// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/repositories/practicum_repository.dart';
import 'package:asco/src/presentation/providers/datasource_providers/practicum_data_source_provider.dart';
import 'package:asco/src/presentation/providers/generated_providers/network_info_provider.dart';

part 'practicum_repository_provider.g.dart';

@riverpod
PracticumRepository practicumRepository(PracticumRepositoryRef ref) {
  return PracticumRepositoryImpl(
    practicumDataSource: ref.watch(practicumDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
