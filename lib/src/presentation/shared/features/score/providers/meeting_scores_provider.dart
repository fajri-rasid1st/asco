// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/scores/score.dart';
import 'package:asco/src/presentation/providers/repository_providers/score_repository_provider.dart';

part 'meeting_scores_provider.g.dart';

@riverpod
class MeetingScores extends _$MeetingScores {
  @override
  Future<List<Score>?> build(
    String meetingId, {
    String type = '',
    String classroom = '',
    String query = '',
  }) async {
    List<Score>? scores;

    state = const AsyncValue.loading();

    final result = await ref.watch(scoreRepositoryProvider).getMeetingScores(
          meetingId,
          type: type,
          classroom: classroom,
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
