// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/assistances/assistance_post.dart';
import 'package:asco/src/presentation/providers/repository_providers/control_card_repository_provider.dart';

part 'update_assistance_provider.g.dart';

@riverpod
class UpdateAssistance extends _$UpdateAssistance {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> updateAssistance(
    String assistanceId,
    AssistancePost assistance,
  ) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(controlCardRepositoryProvider).updateAssistance(
          assistanceId,
          assistance,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = AsyncValue.data(assistance.status),
    );
  }
}
