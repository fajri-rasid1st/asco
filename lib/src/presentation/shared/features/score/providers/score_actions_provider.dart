// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/scores/score_post.dart';
import 'package:asco/src/presentation/providers/repository_providers/score_repository_provider.dart';

part 'score_actions_provider.g.dart';

@riverpod
class ScoreActions extends _$ScoreActions {
  @override
  AsyncValue<Null> build() {
    return const AsyncValue.data(null);
  }

  Future<void> addScore(
    String meetingId,
    ScorePost score,
  ) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(scoreRepositoryProvider).addScore(
          meetingId,
          score,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data(null),
    );
  }

  Future<void> updateScore(
    String id,
    double score,
  ) async {
    state = const AsyncValue.loading();

    final result = await ref.watch(scoreRepositoryProvider).updateScore(
          id,
          score,
        );

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) => state = const AsyncValue.data(null),
    );
  }
}
