// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/utils/http_client.dart';
import 'package:asco/src/data/datasources/assistance_group_data_source.dart';

part 'assistance_group_data_source_provider.g.dart';

@riverpod
AssistanceGroupDataSource assistanceGroupDataSource(AssistanceGroupDataSourceRef ref) {
  return AssistanceGroupDataSourceImpl(client: HttpClient.client);
}
