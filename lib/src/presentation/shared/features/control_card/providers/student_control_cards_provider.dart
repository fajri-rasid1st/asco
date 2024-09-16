// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/src/data/models/control_cards/control_card.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/features/admin/user/providers/user_detail_provider.dart';
import 'package:asco/src/presentation/providers/repository_providers/control_card_repository_provider.dart';

part 'student_control_cards_provider.g.dart';

@riverpod
class StudentControlCards extends _$StudentControlCards {
  @override
  Future<({List<ControlCard>? cards, Profile? student})> build(String practicumId) async {
    List<ControlCard>? cards;
    Profile? student;

    state = const AsyncValue.loading();

    final result = await ref.watch(controlCardRepositoryProvider).getControlCards(practicumId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        cards = r..sort((a, b) => a.meeting!.number!.compareTo(b.meeting!.number!));

        ref.listen(UserDetailProvider(CredentialSaver.credential!.username!), (_, state) {
          state.whenOrNull(
            error: (error, _) => this.state = AsyncValue.error(error, StackTrace.current),
            data: (data) {
              student = data;
              this.state = AsyncValue.data((cards: cards, student: student));
            },
          );
        });
      },
    );

    return (cards: cards, student: student);
  }
}
