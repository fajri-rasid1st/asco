// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/scores/score_recap.dart';
import 'package:asco/src/presentation/providers/repository_providers/score_repository_provider.dart';

part 'leaderboard_provider.g.dart';

@riverpod
class Leaderboard extends _$Leaderboard {
  @override
  Future<(List<ScoreRecap>?, List<ScoreRecap>?)> build(String practicumId) async {
    List<ScoreRecap>? scores;
    List<ScoreRecap>? labExamScores;

    state = const AsyncValue.loading();

    final result = await ref.watch(scoreRepositoryProvider).getScores(practicumId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        scores = r..sort((a, b) => a.finalScore!.compareTo(b.finalScore!) * -1);

        labExamScores = r..sort((a, b) => a.labExamScore!.compareTo(b.labExamScore!) * -1);

        state = AsyncValue.data((scores, labExamScores));
      },
    );

    return (scores, labExamScores);
  }
}
