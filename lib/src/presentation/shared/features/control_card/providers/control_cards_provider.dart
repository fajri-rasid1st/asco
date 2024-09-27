// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/control_cards/control_card.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/features/admin/user/providers/user_detail_provider.dart';
import 'package:asco/src/presentation/providers/repository_providers/control_card_repository_provider.dart';

part 'control_cards_provider.g.dart';

@riverpod
class ControlCards extends _$ControlCards {
  @override
  Future<({List<ControlCard>? cards, Profile? student})> build(
    String practicumId,
    Profile profile,
  ) async {
    List<ControlCard>? cards;
    Profile? student;

    state = const AsyncValue.loading();

    final result = await ref.watch(controlCardRepositoryProvider).getStudentControlCards(
          practicumId,
          profile.id!,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        cards = r..sort((a, b) => a.meeting!.number!.compareTo(b.meeting!.number!));

        ref.listen(
          UserDetailProvider(profile.username!),
          (_, state) => state.whenData((data) {
            student = data;
            this.state = AsyncValue.data((cards: cards, student: student));
          }),
        );
      },
    );

    return (cards: cards, student: student);
  }
}
