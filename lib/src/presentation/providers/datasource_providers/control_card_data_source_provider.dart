// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/utils/http_client.dart';
import 'package:asco/src/data/datasources/control_card_data_source.dart';

part 'control_card_data_source_provider.g.dart';

@riverpod
ControlCardDataSource controlCardDataSource(ControlCardDataSourceRef ref) {
  return ControlCardDataSourceImpl(client: HttpClient.client);
}
