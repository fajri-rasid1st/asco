// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/scores/score_recap.dart';
import 'package:asco/src/presentation/providers/repository_providers/score_repository_provider.dart';

part 'scores_provider.g.dart';

// TODO: need implemented in UI
@riverpod
class Scores extends _$Scores {
  @override
  Future<List<ScoreRecap>?> build(String practicumId) async {
    List<ScoreRecap>? scores;

    state = const AsyncValue.loading();

    final result = await ref.watch(scoreRepositoryProvider).getScores(practicumId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        scores = r..sort((a, b) => a.student!.username!.compareTo(b.student!.username!));
        state = AsyncValue.data(scores);
      },
    );

    return scores;
  }
}
