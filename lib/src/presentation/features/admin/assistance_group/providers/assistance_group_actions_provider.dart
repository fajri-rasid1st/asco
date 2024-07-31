// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/enums/action_type.dart';
import 'package:asco/src/data/models/assistance_groups/assistance_group.dart';
import 'package:asco/src/data/models/assistance_groups/assistance_group_post.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/providers/repository_providers/assistance_group_repository_provider.dart';

part 'assistance_group_actions_provider.g.dart';

@riverpod
class AssistanceGroupActions extends _$AssistanceGroupActions {
  @override
  AsyncValue<({String? message, ActionType action})> build() {
    return const AsyncValue.data((message: null, action: ActionType.none));
  }

  Future<void> createAssistanceGroup(
    String practicumId, {
    required AssistanceGroupPost assistanceGroup,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(assistanceGroupRepositoryProvider).createAssistanceGroup(
          practicumId,
          assistanceGroup: assistanceGroup,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Berhasil menambahkan grup asistensi',
        action: ActionType.create,
      )),
    );
  }

  Future<void> editAssistanceGroup(
    AssistanceGroup oldAssistanceGroup,
    AssistanceGroupPost newAssistanceGroup,
  ) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(assistanceGroupRepositoryProvider).editAssistanceGroup(
          oldAssistanceGroup,
          newAssistanceGroup,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Berhasil mengedit grup asistensi',
        action: ActionType.update,
      )),
    );
  }

  Future<void> deleteAssistanceGroup(String id) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(assistanceGroupRepositoryProvider).deleteAssistanceGroup(id);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Berhasil menghapus grup asistensi',
        action: ActionType.delete,
      )),
    );
  }

  Future<void> removeStudentFromAssistanceGroup(
    String id, {
    required Profile student,
  }) async {
    state = const AsyncValue.loading();

    final result =
        await ref.watch(assistanceGroupRepositoryProvider).removeStudentFromAssistanceGroup(
              id,
              student: student,
            );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data((
        message: 'Praktikan berhasil dikeluarkan',
        action: ActionType.delete,
      )),
    );
  }
}
