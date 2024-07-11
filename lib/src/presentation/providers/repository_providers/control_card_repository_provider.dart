// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/repositories/control_card_repository.dart';
import 'package:asco/src/presentation/providers/datasource_providers/control_card_data_source_provider.dart';
import 'package:asco/src/presentation/providers/generated_providers/network_info_provider.dart';

part 'control_card_repository_provider.g.dart';

@riverpod
ControlCardRepository controlCardRepository(ControlCardRepositoryRef ref) {
  return ControlCardRepositoryImpl(
    controlCardDataSource: ref.watch(controlCardDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
