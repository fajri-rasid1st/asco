// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/control_cards/control_card.dart';
import 'package:asco/src/presentation/providers/repository_providers/control_card_repository_provider.dart';

part 'meeting_control_cards_provider.g.dart';

@riverpod
class MeetingControlCards extends _$MeetingControlCards {
  @override
  Future<List<ControlCard>?> build(String meetingId) async {
    List<ControlCard>? cards;

    state = const AsyncValue.loading();

    final result = await ref.watch(controlCardRepositoryProvider).getMeetingControlCards(meetingId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        cards = r;
        state = AsyncValue.data(cards);
      },
    );

    return cards;
  }
}
