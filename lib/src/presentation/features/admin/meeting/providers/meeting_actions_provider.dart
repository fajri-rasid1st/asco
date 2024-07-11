// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/enums/action_type.dart';
import 'package:asco/src/data/models/meetings/meeting_post.dart';
import 'package:asco/src/presentation/providers/repository_providers/meeting_repository_provider.dart';

part 'meeting_actions_provider.g.dart';

@riverpod
class MeetingActions extends _$MeetingActions {
  @override
  AsyncValue<({String? message, ActionType action})> build() {
    return const AsyncValue.data((message: null, action: ActionType.none));
  }

  Future<void> addMeetingToPracticum(
    String practicumId, {
    required MeetingPost meeting,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(meetingRepositoryProvider).addMeetingToPracticum(
          practicumId,
          meeting: meeting,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Berhasil menambahkan pertemuan',
        action: ActionType.create,
      )),
    );
  }
}
