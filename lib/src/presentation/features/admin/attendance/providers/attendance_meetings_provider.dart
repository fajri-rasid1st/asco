// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/attendances/attendance_meeting.dart';
import 'package:asco/src/presentation/providers/repository_providers/attendance_repository_provider.dart';

part 'attendance_meetings_provider.g.dart';

@riverpod
class AttendanceMeetings extends _$AttendanceMeetings {
  @override
  Future<List<AttendanceMeeting>?> build(String practicumId) async {
    List<AttendanceMeeting>? attendanceMeetings;

    state = const AsyncValue.loading();

    final result = await ref.watch(attendanceRepositoryProvider).getAttendanceMeetings(practicumId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        attendanceMeetings = r..sort((a, b) => a.number!.compareTo(b.number!));
        state = AsyncValue.data(attendanceMeetings);
      },
    );

    return attendanceMeetings;
  }
}
