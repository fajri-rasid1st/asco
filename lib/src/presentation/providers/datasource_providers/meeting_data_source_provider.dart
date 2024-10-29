// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/utils/http_client.dart';
import 'package:asco/src/data/datasources/meeting_data_source.dart';

part 'meeting_data_source_provider.g.dart';

@riverpod
MeetingDataSource meetingDataSource(Ref ref) {
  return MeetingDataSourceImpl(client: HttpClient.client);
}
