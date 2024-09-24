// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/scores/score_recap.dart';
import 'package:asco/src/presentation/providers/repository_providers/score_repository_provider.dart';

part 'student_score_detail_provider.g.dart';

// TODO: need implemented in UI
@riverpod
class StudentScoreDetail extends _$StudentScoreDetail {
  @override
  Future<ScoreRecap?> build(String practicumId) async {
    ScoreRecap? score;

    state = const AsyncValue.loading();

    final result = await ref.watch(scoreRepositoryProvider).getScoreDetail(practicumId);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        score = r.copyWith(
          assignmentScores: r.assignmentScores
            ?..sort(
              (a, b) => a.meetingNumber!.compareTo(b.meetingNumber!),
            ),
          quizScores: r.quizScores
            ?..sort(
              (a, b) => a.meetingNumber!.compareTo(b.meetingNumber!),
            ),
          responseScores: r.responseScores
            ?..sort(
              (a, b) => a.meetingNumber!.compareTo(b.meetingNumber!),
            ),
        );

        state = AsyncValue.data(score);
      },
    );

    return score;
  }
}
