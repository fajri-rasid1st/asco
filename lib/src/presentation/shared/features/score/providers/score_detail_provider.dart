// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/scores/score_recap.dart';
import 'package:asco/src/presentation/providers/repository_providers/score_repository_provider.dart';

part 'score_detail_provider.g.dart';

@riverpod
class ScoreDetail extends _$ScoreDetail {
  @override
  Future<ScoreRecap?> build(
    String practicumId,
    String username,
  ) async {
    ScoreRecap? score;

    state = const AsyncValue.loading();

    final result = await ref.watch(scoreRepositoryProvider).getStudentScoreDetail(
          practicumId,
          username,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        score = r;
        state = AsyncValue.data(score);
      },
    );

    return score;
  }
}
