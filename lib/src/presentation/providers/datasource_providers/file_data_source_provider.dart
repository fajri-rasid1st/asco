// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/utils/http_client.dart';
import 'package:asco/src/data/datasources/file_data_source.dart';

part 'file_data_source_provider.g.dart';

@riverpod
FileDataSource fileDataSource(FileDataSourceRef ref) {
  return FileDataSourceImpl(client: HttpClient.client);
}
