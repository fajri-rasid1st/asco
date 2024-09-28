// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/presentation/providers/repository_providers/meeting_repository_provider.dart';

part 'classroom_meetings_provider.g.dart';

@riverpod
class ClassroomMeetings extends _$ClassroomMeetings {
  @override
  Future<List<Meeting>?> build(
    String classroomId, {
    bool asc = true,
  }) async {
    List<Meeting>? meetings;

    state = const AsyncValue.loading();

    final result = await ref.watch(meetingRepositoryProvider).getClassroomMeetings(
          classroomId,
          asc: asc,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        meetings = r;
        state = AsyncValue.data(meetings);
      },
    );

    return meetings;
  }
}
