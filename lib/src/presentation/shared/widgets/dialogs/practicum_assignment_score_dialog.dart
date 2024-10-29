// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/scores/score.dart';
import 'package:asco/src/data/models/scores/score_post.dart';
import 'package:asco/src/presentation/shared/features/score/providers/score_actions_provider.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/custom_dialog.dart';

class PracticumAssignmentScoreDialog extends ConsumerStatefulWidget {
  final Meeting meeting;
  final Score score;
  final String studentId;

  const PracticumAssignmentScoreDialog({
    super.key,
    required this.meeting,
    required this.score,
    required this.studentId,
  });

  @override
  ConsumerState<PracticumAssignmentScoreDialog> createState() => _PracticumAssignmentScoreDialogState();
}

class _PracticumAssignmentScoreDialogState extends ConsumerState<PracticumAssignmentScoreDialog> {
  late final List<PracticumAssignmentScore> assignmentScores;
  late final ValueNotifier<PracticumAssignmentScore> scoreNotifier;

  @override
  void initState() {
    assignmentScores = [
      const PracticumAssignmentScore(1, Palette.errorText, 50.0, "Sangat Rendah"),
      const PracticumAssignmentScore(2, Palette.error, 65.0, "Rendah"),
      const PracticumAssignmentScore(3, Palette.warning, 75.0, "Cukup"),
      const PracticumAssignmentScore(4, Palette.info, 80.0, "Sedang"),
      const PracticumAssignmentScore(5, Palette.info, 85.0, "Lumayan"),
      const PracticumAssignmentScore(6, Palette.success, 92.0, "Bagus"),
      const PracticumAssignmentScore(7, Palette.success, 98.0, "Sangat Bagus"),
    ];

    final index = MapHelper.assignmentScoreMap[widget.score.score];

    scoreNotifier = ValueNotifier(assignmentScores[index != null ? index - 1 : 4]);

    super.initState();
  }

  @override
  void dispose() {
    scoreNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Tugas Praktikum ${widget.meeting.number}',
      onPressedPrimaryAction: submit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.score.student?.username}',
            style: textTheme.bodyMedium!.copyWith(
              color: Palette.purple3,
            ),
          ),
          Text(
            '${widget.score.student?.fullname}',
            style: textTheme.titleLarge!.copyWith(
              color: Palette.purple2,
            ),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: scoreNotifier,
            builder: (context, score, child) {
              return Center(
                child: Column(
                  children: [
                    RatingBar(
                      initialRating: score.rate.toDouble(),
                      minRating: 1,
                      itemCount: 7,
                      itemSize: 34,
                      glow: false,
                      updateOnDrag: true,
                      ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star_rounded,
                          color: score.color,
                        ),
                        half: const SizedBox(),
                        empty: Icon(
                          Icons.star_outline_rounded,
                          color: score.color,
                        ),
                      ),
                      onRatingUpdate: (value) {
                        if (value > 0 && value <= 7) {
                          scoreNotifier.value = assignmentScores[value.toInt() - 1];
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${score.description}"',
                      style: textTheme.titleMedium!.copyWith(
                        color: score.color,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void submit() {
    final assignmentScore = scoreNotifier.value.value;

    if (widget.score.id != null) {
      ref.read(scoreActionsProvider.notifier).updateScore(widget.score.id!, assignmentScore);
    } else {
      final scorePost = ScorePost(
        studentId: widget.studentId,
        score: assignmentScore,
        type: 'ASSIGNMENT',
      );

      ref.read(scoreActionsProvider.notifier).addScore(widget.meeting.id!, scorePost);
    }
  }
}

class PracticumAssignmentScore {
  final int rate;
  final Color color;
  final double value;
  final String description;

  const PracticumAssignmentScore(
    this.rate,
    this.color,
    this.value,
    this.description,
  );
}
