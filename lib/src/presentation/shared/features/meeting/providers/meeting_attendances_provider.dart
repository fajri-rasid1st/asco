// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/attendances/attendance.dart';
import 'package:asco/src/presentation/providers/repository_providers/attendance_repository_provider.dart';

part 'meeting_attendances_provider.g.dart';

// TODO: need implemented in assistant feature
@riverpod
class MeetingAttendances extends _$MeetingAttendances {
  @override
  Future<List<Attendance>?> build(
    String meetingId, {
    String classroomId = '',
  }) async {
    List<Attendance>? attendances;

    state = const AsyncValue.loading();

    final result = await ref.watch(attendanceRepositoryProvider).getMeetingAttendances(
          meetingId,
          classroomId: classroomId,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        attendances = r..sort((a, b) => a.student!.username!.compareTo(b.student!.username!));
        state = AsyncValue.data(attendances);
      },
    );

    return attendances;
  }
}
