// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/scores/score_recap.dart';
import 'package:asco/src/presentation/providers/repository_providers/meeting_repository_provider.dart';
import 'package:asco/src/presentation/shared/features/score/providers/student_score_detail_provider.dart';

part 'student_meeting_detail_provider.g.dart';

@riverpod
class StudentMeetingDetail extends _$StudentMeetingDetail {
  @override
  Future<({Meeting? meeting, ScoreRecap? score})> build(String id) async {
    Meeting? meeting;
    ScoreRecap? score;

    state = const AsyncValue.loading();

    final result = await ref.watch(meetingRepositoryProvider).getMeetingDetail(id);

    result.fold(
      (l) => state = AsyncValue.error(l.message!, StackTrace.current),
      (r) {
        meeting = r;

        ref.listen(
          StudentScoreDetailProvider(r.practicum!.id!),
          (_, state) => state.whenData((data) {
            score = data;

            this.state = AsyncValue.data((meeting: meeting, score: score));
          }),
        );
      },
    );

    return (meeting: meeting, score: score);
  }
}
