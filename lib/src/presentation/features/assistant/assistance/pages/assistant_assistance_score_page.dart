// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/datetime_extension.dart';
import 'package:asco/core/extensions/iterable_extension.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/control_cards/control_card.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/scores/score.dart';
import 'package:asco/src/presentation/shared/features/score/providers/meeting_scores_provider.dart';
import 'package:asco/src/presentation/shared/features/score/providers/score_actions_provider.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/custom_information.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/practicum_assignment_score_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

class AssistantAssistanceScorePage extends StatelessWidget {
  final AssistantAssistanceScorePageArgs args;

  const AssistantAssistanceScorePage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Nilai Tugas Praktikum',
      ),
      body: Consumer(
        builder: (context, ref, child) {
          ref.listen(
            MeetingScoresProvider(
              args.meeting.id!,
              type: 'ASSIGNMENT',
            ),
            (_, state) => state.whenOrNull(error: context.responseError),
          );

          ref.listen(scoreActionsProvider, (_, state) {
            state.whenOrNull(
              loading: () => context.showLoadingDialog(),
              error: (error, stackTrace) {
                navigatorKey.currentState!.pop();
                navigatorKey.currentState!.pop();
                context.responseError(error, stackTrace);
              },
              data: (data) {
                navigatorKey.currentState!.pop();
                navigatorKey.currentState!.pop();
                ref.invalidate(meetingScoresProvider);
              },
            );
          });

          final scores = ref.watch(
            MeetingScoresProvider(
              args.meeting.id!,
              type: 'ASSIGNMENT',
            ),
          );

          return scores.when(
            loading: () => const LoadingIndicator(),
            error: (_, __) => const SizedBox(),
            data: (scores) {
              if (scores == null) return const SizedBox();

              if (scores.isEmpty) {
                return const CustomInformation(
                  title: 'Daftar nilai masih kosong',
                  subtitle: 'Nilai asistensi pada pertemuan ini belum ada',
                );
              }

              final assignmentScores = scores.where((e) {
                final usernames = args.cards.map((e) => e.student?.username);

                return usernames.contains(e.student?.username);
              }).sortedBy((e) => e.student!.username!);

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) => AssistanceScoreCard(
                  meeting: args.meeting,
                  score: assignmentScores[index],
                  card: args.cards[index],
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemCount: assignmentScores.length,
              );
            },
          );
        },
      ),
    );
  }
}

class AssistanceScoreCard extends StatelessWidget {
  final Meeting meeting;
  final Score score;
  final ControlCard card;

  const AssistanceScoreCard({
    super.key,
    required this.meeting,
    required this.score,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: Palette.background,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      border: Border.all(
        color: Palette.purple2,
      ),
      boxShadow: const [
        BoxShadow(
          offset: Offset(3, 4),
          color: Palette.purple2,
        ),
      ],
      onTap: () => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PracticumAssignmentScoreDialog(
          meeting: meeting,
          score: score,
          studentId: card.student!.id!,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${card.student?.username}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.purple3,
                  ),
                ),
                Text(
                  '${card.student?.fullname}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall!.copyWith(
                    color: Palette.purple2,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keterangan Asistensi 1 & 2',
                  style: textTheme.labelSmall,
                ),
                const SizedBox(height: 4),
                CustomBadge(
                  color: getAssistanceLabelColor(card.firstAssistance!.status!).withOpacity(.2),
                  text: getAssistanceLabelText(card.firstAssistance!.status!),
                  textStyle: textTheme.labelSmall!.copyWith(
                    color: getAssistanceLabelColor(card.firstAssistance!.status!),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                CustomBadge(
                  color: getAssistanceLabelColor(card.secondAssistance!.status!).withOpacity(.2),
                  text: getAssistanceLabelText(card.secondAssistance!.status!),
                  textStyle: textTheme.labelSmall!.copyWith(
                    color: getAssistanceLabelColor(card.secondAssistance!.status!),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          CircularPercentIndicator(
            percent: score.score != null ? score.score! / 100 : 0,
            radius: 45,
            lineWidth: 9,
            progressColor: Palette.purple3,
            backgroundColor: Colors.transparent,
            circularStrokeCap: CircularStrokeCap.round,
            center: Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.purple2,
              ),
              child: Center(
                child: Text(
                  '${MapHelper.assignmentScoreMap[score.score] ?? '?'}',
                  style: textTheme.headlineSmall!.copyWith(
                    color: Palette.background,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get isLate => meeting.assistanceDeadline! <= DateTime.now().secondsSinceEpoch;

  String getAssistanceLabelText(bool status) {
    return status
        ? isLate
            ? 'Terlambat'
            : 'Tepat Waktu'
        : 'Belum Asistensi';
  }

  Color getAssistanceLabelColor(bool status) {
    return status
        ? isLate
            ? Palette.pink2
            : Palette.purple3
        : Palette.disabledText;
  }
}

class AssistantAssistanceScorePageArgs {
  final Meeting meeting;
  final List<ControlCard> cards;

  const AssistantAssistanceScorePageArgs({
    required this.meeting,
    required this.cards,
  });
}
