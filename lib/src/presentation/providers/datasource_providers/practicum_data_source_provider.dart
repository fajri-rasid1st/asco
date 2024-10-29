// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/utils/http_client.dart';
import 'package:asco/src/data/datasources/practicum_data_source.dart';

part 'practicum_data_source_provider.g.dart';

@riverpod
PracticumDataSource practicumDataSource(Ref ref) {
  return PracticumDataSourceImpl(client: HttpClient.client);
}
