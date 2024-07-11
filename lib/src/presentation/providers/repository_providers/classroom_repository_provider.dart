// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/repositories/classroom_repository.dart';
import 'package:asco/src/presentation/providers/datasource_providers/classroom_data_source_provider.dart';
import 'package:asco/src/presentation/providers/generated_providers/network_info_provider.dart';

part 'classroom_repository_provider.g.dart';

@riverpod
ClassroomRepository classroomRepository(ClassroomRepositoryRef ref) {
  return ClassroomRepositoryImpl(
    classroomDataSource: ref.watch(classroomDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
