// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/enums/action_type.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/meetings/meeting_post.dart';
import 'package:asco/src/presentation/providers/repository_providers/meeting_repository_provider.dart';

part 'meeting_actions_provider.g.dart';

@riverpod
class MeetingActions extends _$MeetingActions {
  @override
  AsyncValue<({String? message, ActionType action})> build() {
    return const AsyncValue.data((message: null, action: ActionType.none));
  }

  Future<void> createMeeting(
    String practicumId, {
    required MeetingPost meeting,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(meetingRepositoryProvider).createMeeting(
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

  Future<void> editMeeting(
    Meeting oldMeeting,
    MeetingPost newMeeting,
  ) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(meetingRepositoryProvider).editMeeting(
          oldMeeting,
          newMeeting,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Berhasil mengedit pertemuan',
        action: ActionType.update,
      )),
    );
  }

  Future<void> deleteMeeting(String id) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(meetingRepositoryProvider).deleteMeeting(id);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Berhasil menghapus pertemuan',
        action: ActionType.delete,
      )),
    );
  }
}
