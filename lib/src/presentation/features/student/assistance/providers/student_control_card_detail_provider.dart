// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/control_cards/control_card.dart';
import 'package:asco/src/presentation/providers/repository_providers/control_card_repository_provider.dart';

part 'student_control_card_detail_provider.g.dart';

// TODO: need implemented in UI
@riverpod
class StudentControlCardDetail extends _$StudentControlCardDetail {
  @override
  Future<ControlCard?> build(String id) async {
    ControlCard? card;

    state = const AsyncValue.loading();

    final result = await ref.watch(controlCardRepositoryProvider).getControlCardDetail(id);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        card = r;
        state = AsyncValue.data(card);
      },
    );

    return card;
  }
}
