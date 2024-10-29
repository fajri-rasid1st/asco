// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/repositories/assistance_group_repository.dart';
import 'package:asco/src/presentation/providers/datasource_providers/assistance_group_data_source_provider.dart';
import 'package:asco/src/presentation/providers/generated_providers/network_info_provider.dart';

part 'assistance_group_repository_provider.g.dart';

@riverpod
AssistanceGroupRepository assistanceGroupRepository(Ref ref) {
  return AssistanceGroupRepositoryImpl(
    assistanceGroupDataSource: ref.watch(assistanceGroupDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
