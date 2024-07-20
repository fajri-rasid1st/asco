// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/control_cards/control_card.dart';
import 'package:asco/src/presentation/providers/repository_providers/control_card_repository_provider.dart';

part 'control_cards_provider.g.dart';

@riverpod
class ControlCards extends _$ControlCards {
  @override
  Future<List<ControlCard>?> build(String practicumId) async {
    List<ControlCard>? controlCards;

    state = const AsyncValue.loading();

    final result = await ref.watch(controlCardRepositoryProvider).getControlCards(practicumId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        controlCards = r;
        state = AsyncValue.data(controlCards);
      },
    );

    return controlCards;
  }
}
