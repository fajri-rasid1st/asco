// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/repositories/score_repository.dart';
import 'package:asco/src/presentation/providers/datasource_providers/score_data_source_provider.dart';
import 'package:asco/src/presentation/providers/generated_providers/network_info_provider.dart';

part 'score_repository_provider.g.dart';

@riverpod
ScoreRepository scoreRepository(ScoreRepositoryRef ref) {
  return ScoreRepositoryImpl(
    scoreDataSource: ref.watch(scoreDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
