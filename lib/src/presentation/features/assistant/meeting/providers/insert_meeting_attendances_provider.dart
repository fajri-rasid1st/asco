// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/presentation/providers/repository_providers/attendance_repository_provider.dart';

part 'insert_meeting_attendances_provider.g.dart';

// TODO: need implemented in UI
@riverpod
class InsertMeetingAttendances extends _$InsertMeetingAttendances {
  @override
  Future<bool> build(String meetingId) async {
    bool success = false;

    state = const AsyncValue.loading();

    final result =
        await ref.watch(attendanceRepositoryProvider).insertMeetingAttendances(meetingId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        success = true;
        state = AsyncValue.data(success);
      },
    );

    return success;
  }
}
