// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/core/enums/model_attributes.dart';
import 'package:asco/src/data/models/scores/score_recap.dart';
import 'package:asco/src/presentation/providers/repository_providers/score_repository_provider.dart';

part 'scores_provider.g.dart';

@riverpod
class Scores extends _$Scores {
  @override
  Future<List<ScoreRecap>?> build(
    String practicumId, {
    String query = '',
    ScoreAttribute sortedBy = ScoreAttribute.username,
    bool asc = true,
  }) async {
    List<ScoreRecap>? scores;

    state = const AsyncValue.loading();

    final result = await ref.watch(scoreRepositoryProvider).getScores(
          practicumId,
          query: query,
          sortedBy: sortedBy,
          asc: asc,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        scores = r;
        state = AsyncValue.data(scores);
      },
    );

    return scores;
  }
}
