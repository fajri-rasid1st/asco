// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/repositories/meeting_repository.dart';
import 'package:asco/src/presentation/providers/datasource_providers/meeting_data_source_provider.dart';
import 'package:asco/src/presentation/providers/generated_providers/network_info_provider.dart';

part 'meeting_repository_provider.g.dart';

@riverpod
MeetingRepository meetingRepository(Ref ref) {
  return MeetingRepositoryImpl(
    meetingDataSource: ref.watch(meetingDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
