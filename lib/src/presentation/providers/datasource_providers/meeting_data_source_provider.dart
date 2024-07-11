// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/utils/http_client.dart';
import 'package:asco/src/data/datasources/meeting_data_source.dart';

part 'meeting_data_source_provider.g.dart';

@riverpod
MeetingDataSource meetingDataSource(MeetingDataSourceRef ref) {
  return MeetingDataSourceImpl(client: HttpClient.client);
}
