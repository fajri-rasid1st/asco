// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/enums/action_type.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/providers/repository_providers/classroom_repository_provider.dart';

part 'classroom_actions_provider.g.dart';

@riverpod
class ClassroomActions extends _$ClassroomActions {
  @override
  AsyncValue<({String? message, ActionType action})> build() {
    return const AsyncValue.data((message: null, action: ActionType.none));
  }

  Future<void> addStudentsToClassroom(
    String id, {
    required List<Profile> students,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(classroomRepositoryProvider).addStudentsToClassroom(
          id,
          students: students,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Praktikan berhasil ditambahkan ke dalam kelas',
        action: ActionType.create,
      )),
    );
  }

  Future<void> removeStudentFromClassroom(
    String id, {
    required Profile student,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(classroomRepositoryProvider).removeStudentFromClassroom(
          id,
          student: student,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Berhasil mengeluarkan praktikan',
        action: ActionType.delete,
      )),
    );
  }
}
