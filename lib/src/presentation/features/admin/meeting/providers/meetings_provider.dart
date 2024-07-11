// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/presentation/providers/repository_providers/meeting_repository_provider.dart';

part 'meetings_provider.g.dart';

@riverpod
class Meetings extends _$Meetings {
  @override
  Future<List<Meeting>?> build(String practicumId) async {
    List<Meeting>? meetings;

    state = const AsyncValue.loading();

    final result = await ref.watch(meetingRepositoryProvider).getMeetings(practicumId);

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
