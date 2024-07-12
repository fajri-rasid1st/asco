// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/assistance_groups/assistance_group.dart';
import 'package:asco/src/presentation/providers/repository_providers/assistance_group_repository_provider.dart';

part 'assistance_group_detail_provider.g.dart';

@riverpod
class AssistanceGroupDetail extends _$AssistanceGroupDetail {
  @override
  Future<AssistanceGroup?> build(String practicumId) async {
    AssistanceGroup? assistanceGroups;

    state = const AsyncValue.loading();

    final result =
        await ref.watch(assistanceGroupRepositoryProvider).getAssistanceGroupDetail(practicumId);

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
