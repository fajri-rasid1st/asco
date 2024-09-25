// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/utils/http_client.dart';
import 'package:asco/src/data/datasources/score_data_source.dart';

part 'score_data_source_provider.g.dart';

@riverpod
ScoreDataSource scoreDataSource(ScoreDataSourceRef ref) {
  return ScoreDataSourceImpl(client: HttpClient.client);
}