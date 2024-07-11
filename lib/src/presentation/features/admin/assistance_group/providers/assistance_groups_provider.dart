// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/assistance_groups/assistance_group.dart';
import 'package:asco/src/presentation/providers/repository_providers/assistance_group_repository_provider.dart';

part 'assistance_groups_provider.g.dart';

@riverpod
class AssistanceGroups extends _$AssistanceGroups {
  @override
  Future<List<AssistanceGroup>?> build(String practicumId) async {
    List<AssistanceGroup>? assistanceGroups;

    state = const AsyncValue.loading();

    final result =
        await ref.watch(assistanceGroupRepositoryProvider).getAssistanceGroups(practicumId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        assistanceGroups = r;
        state = AsyncValue.data(assistanceGroups);
      },
    );

    return assistanceGroups;
  }
}
