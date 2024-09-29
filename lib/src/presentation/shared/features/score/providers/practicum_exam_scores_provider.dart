// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/scores/score.dart';
import 'package:asco/src/presentation/providers/repository_providers/score_repository_provider.dart';

part 'practicum_exam_scores_provider.g.dart';

@riverpod
class PracticumExamScores extends _$PracticumExamScores {
  @override
  Future<List<Score>?> build(
    String practicumId, {
    String query = '',
  }) async {
    List<Score>? scores;

    state = const AsyncValue.loading();

    final result = await ref.watch(scoreRepositoryProvider).getPracticumExamScores(
          practicumId,
          query: query,
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
