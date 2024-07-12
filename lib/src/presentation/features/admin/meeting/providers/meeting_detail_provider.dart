// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/presentation/providers/repository_providers/meeting_repository_provider.dart';

part 'meeting_detail_provider.g.dart';

@riverpod
class MeetingDetail extends _$MeetingDetail {
  @override
  Future<Meeting?> build(String id) async {
    Meeting? meeting;

    state = const AsyncValue.loading();

    final result = await ref.watch(meetingRepositoryProvider).getMeetingDetail(id);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        meeting = r;
        state = AsyncValue.data(meeting);
      },
    );

    return meeting;
  }
}
