// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/utils/http_client.dart';
import 'package:asco/src/data/datasources/classroom_data_source.dart';

part 'classroom_data_source_provider.g.dart';

@riverpod
ClassroomDataSource classroomDataSource(Ref ref) {
  return ClassroomDataSourceImpl(client: HttpClient.client);
}
