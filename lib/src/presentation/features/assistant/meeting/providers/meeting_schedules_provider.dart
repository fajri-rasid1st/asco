// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/meetings/meeting_schedule.dart';
import 'package:asco/src/presentation/providers/repository_providers/meeting_repository_provider.dart';

part 'meeting_schedules_provider.g.dart';

@riverpod
class MeetingSchedules extends _$MeetingSchedules {
  @override
  Future<List<MeetingSchedule>?> build({String practicum = ''}) async {
    List<MeetingSchedule>? schedules;

    state = const AsyncValue.loading();

    final result =
        await ref.watch(meetingRepositoryProvider).getMeetingSchedules(practicum: practicum);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        schedules = r;
        state = AsyncValue.data(schedules);
      },
    );

    return schedules;
  }
}
