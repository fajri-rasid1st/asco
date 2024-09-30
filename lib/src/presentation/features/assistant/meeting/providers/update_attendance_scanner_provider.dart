// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/attendances/attendance_post.dart';
import 'package:asco/src/presentation/providers/repository_providers/attendance_repository_provider.dart';

part 'update_attendance_scanner_provider.g.dart';

@riverpod
class UpdateAttendanceScanner extends _$UpdateAttendanceScanner {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> updateAttendanceScanner(
    String meetingId,
    AttendancePost attendance,
  ) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(attendanceRepositoryProvider).updateAttendanceScanner(
          meetingId,
          attendance,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = AsyncValue.data(attendance.studentId),
    );
  }
}
