// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/enums/action_type.dart';
import 'package:asco/src/data/models/classrooms/classroom_post.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/practicums/practicum_post.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/providers/repository_providers/practicum_repository_provider.dart';

part 'practicum_actions_provider.g.dart';

@riverpod
class PracticumActions extends _$PracticumActions {
  @override
  AsyncValue<({String? message, ActionType action})> build() {
    return const AsyncValue.data((message: null, action: ActionType.none));
  }

  Future<String?> createPracticum(PracticumPost practicum) async {
    String? data;

    state = const AsyncValue.loading();

    final result = await ref.watch(practicumRepositoryProvider).createPracticum(practicum);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        data = r;
        state = AsyncValue.data((
          message: 'Berhasil menambahkan praktikum:$data',
          action: ActionType.create,
        ));
      },
    );

    return data;
  }

  Future<String?> editPracticum(Practicum oldPracticum, PracticumPost newPracticum) async {
    String? data;

    state = const AsyncValue.loading();

    final result = await ref.watch(practicumRepositoryProvider).editPracticum(
          oldPracticum,
          newPracticum,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        data = r;
        state = AsyncValue.data((
          message: 'Berhasil mengedit praktikum:$data',
          action: ActionType.update,
        ));
      },
    );

    return data;
  }

  Future<void> deletePracticum(String id) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(practicumRepositoryProvider).deletePracticum(id);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Berhasil menghapus praktikum',
        action: ActionType.delete,
      )),
    );
  }

  Future<void> updateClassroomsAndAssistants(
    String id, {
    required List<ClassroomPost> classrooms,
    required List<Profile> assistants,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(practicumRepositoryProvider).updateClassroomsAndAssistants(
          id,
          classrooms: classrooms,
          assistants: assistants,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Berhasil mengupdate kelas dan asisten praktikum',
        action: ActionType.update,
      )),
    );
  }

  Future<void> removeClassroomFromPracticum(String classroomId) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(practicumRepositoryProvider).removeClassroomFromPracticum(classroomId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Berhasil menghapus kelas dari praktikum',
        action: ActionType.delete,
      )),
    );
  }

  Future<void> removeAssistantFromPracticum(String id, {required Profile assistant}) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(practicumRepositoryProvider).removeAssistantFromPracticum(
          id,
          assistant: assistant,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Berhasil mengeluarkan asisten dari praktikum',
        action: ActionType.delete,
      )),
    );
  }
}
