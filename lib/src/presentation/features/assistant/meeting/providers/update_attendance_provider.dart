// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/attendances/attendance_post.dart';
import 'package:asco/src/presentation/providers/repository_providers/attendance_repository_provider.dart';

part 'update_attendance_provider.g.dart';

@riverpod
class UpdateAttendance extends _$UpdateAttendance {
  @override
  AsyncValue<String?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> updateAttendance(
    String id,
    AttendancePost attendance,
  ) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(attendanceRepositoryProvider).updateAttendance(
          id,
          attendance,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = AsyncValue.data(attendance.status),
    );
  }
}
