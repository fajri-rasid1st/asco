// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/attendances/attendance.dart';
import 'package:asco/src/presentation/providers/repository_providers/attendance_repository_provider.dart';

part 'student_attendances_provider.g.dart';

// TODO: need implemented in UI
@riverpod
class StudentAttendances extends _$StudentAttendances {
  @override
  Future<List<Attendance>?> build(String practicumId) async {
    List<Attendance>? attendances;

    state = const AsyncValue.loading();

    final result = await ref.watch(attendanceRepositoryProvider).getAttendances(practicumId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        attendances = r..sort((a, b) => a.meeting!.number!.compareTo(b.meeting!.number!));
        state = AsyncValue.data(attendances);
      },
    );

    return attendances;
  }
}
