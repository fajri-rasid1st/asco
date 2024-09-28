// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/presentation/providers/repository_providers/attendance_repository_provider.dart';

part 'insert_meeting_attendances_provider.g.dart';

@riverpod
class InsertMeetingAttendances extends _$InsertMeetingAttendances {
  @override
  Future<Null> build(String meetingId) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(attendanceRepositoryProvider).insertMeetingAttendances(meetingId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data(null),
    );
  }
}
