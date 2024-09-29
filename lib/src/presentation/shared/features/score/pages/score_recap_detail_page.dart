// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// Project imports:
import 'package:asco/core/enums/score_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/data/models/scores/score.dart';
import 'package:asco/src/presentation/shared/features/score/providers/score_detail_provider.dart';
import 'package:asco/src/presentation/shared/features/score/providers/student_score_detail_provider.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

class ScoreRecapDetailPage extends ConsumerWidget {
  final ScoreRecapDetailPageArgs args;

  const ScoreRecapDetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreDetailProvider = args.username != null
        ? ScoreDetailProvider(args.practicumId, args.username!)
        : StudentScoreDetailProvider(args.practicumId);

    final score = ref.watch(scoreDetailProvider);

    ref.listen(scoreDetailProvider, (_, state) {
      state.whenOrNull(error: context.responseError);
    });

    return score.when(
      loading: () => const LoadingIndicator(withScaffold: true),
      error: (_, __) => const Scaffold(),
      data: (score) {
        if (score == null) return const Scaffold();

        final scoreRecapCards = [
          ScoreRecapCard(
            title: 'NILAI UJIAN LAB',
            value: score.labExamScore!.toStringAsFixed(1),
            color: Palette.orange1,
            backgroundColor: Palette.orange3,
          ),
          ScoreRecapCard(
            title: 'NILAI ASISTENSI',
            value: score.assignmentAverageScore!.toStringAsFixed(1),
            color: Palette.purple3,
            backgroundColor: Palette.purple5,
          ),
          ScoreRecapCard(
            title: 'NILAI QUIZ',
            value: score.quizAverageScore!.toStringAsFixed(1),
            color: Palette.violet1,
            backgroundColor: Palette.violet5,
          ),
          ScoreRecapCard(
            title: 'NILAI RESPON',
            value: score.responseAverageScore!.toStringAsFixed(1),
            color: Palette.info,
            backgroundColor: const Color(0xFFE3EBFF),
          ),
        ];

        return Scaffold(
          appBar: CustomAppBar(
            title: '${score.student?.fullname}',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Palette.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Nilai Akhir',
                        style: textTheme.titleMedium!.copyWith(
                          color: Palette.purple2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CircularPercentIndicator(
                        percent: score.finalScore! / 100,
                        animation: true,
                        reverse: true,
                        animationDuration: 1000,
                        curve: Curves.easeOut,
                        radius: 80,
                        lineWidth: 6,
                        backgroundWidth: 36,
                        progressColor: Palette.purple3,
                        backgroundColor: Palette.purple5,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getScorePredicate(score.finalScore!),
                              style: textTheme.displaySmall!.copyWith(
                                color: Palette.purple2,
                              ),
                            ),
                            Text(
                              score.finalScore!.toStringAsFixed(1),
                              style: textTheme.titleMedium!.copyWith(
                                color: Palette.purple2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 14,
                          childAspectRatio: 16 / 9,
                        ),
                        itemBuilder: (context, index) => scoreRecapCards[index],
                        itemCount: scoreRecapCards.length,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        dividerHeight: 0,
                        indicatorWeight: 6,
                        labelStyle: textTheme.titleMedium!.copyWith(
                          color: Palette.purple2,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: textTheme.bodyLarge!.copyWith(
                          color: Palette.disabledText,
                        ),
                        splashBorderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        tabs: const [
                          Tab(
                            text: 'Asistensi',
                            height: 36,
                          ),
                          Tab(
                            text: 'Kuis',
                            height: 36,
                          ),
                          Tab(
                            text: 'Respon',
                            height: 36,
                          ),
                        ],
                      ),
                      Container(
                        height: AppSize.getAppHeight(context) / 2,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Palette.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TabBarView(
                          children: [
                            MeetingScoreList(
                              scores: score.assignmentScores!,
                              type: ScoreType.assignment,
                            ),
                            MeetingScoreList(
                              scores: score.quizScores!,
                              type: ScoreType.quiz,
                            ),
                            MeetingScoreList(
                              scores: score.responseScores!,
                              type: ScoreType.response,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String getScorePredicate(double score) {
    if (score >= 95) return 'A';
    if (score >= 90) return 'A-';
    if (score >= 85) return 'B+';
    if (score >= 80) return 'B';
    if (score >= 70) return 'B-';
    if (score >= 60) return 'C';
    if (score >= 50) return 'D';

    return 'E';
  }
}

class ScoreRecapCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color backgroundColor;

  const ScoreRecapCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodyMedium!.copyWith(
              color: Palette.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 4,
                height: 26,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MeetingScoreList extends StatelessWidget {
  final List<Score> scores;
  final ScoreType type;

  const MeetingScoreList({
    super.key,
    required this.scores,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      shrinkWrap: true,
      itemBuilder: (context, index) => ListTile(
        horizontalTitleGap: 12,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Palette.purple3,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${scores[index].meetingNumber}',
              style: textTheme.titleMedium!.copyWith(
                color: Palette.background,
                height: 1,
              ),
            ),
          ),
        ),
        title: Text(
          '${scores[index].meetingName}',
          style: textTheme.bodyMedium!.copyWith(
            color: Palette.purple3,
          ),
        ),
        subtitle: Text(
          switch (type) {
            ScoreType.assignment => '${scores[index].assignmentScore}',
            ScoreType.quiz => '${scores[index].quizScore}',
            ScoreType.response => '${scores[index].responseScore}',
            ScoreType.exam => '',
          },
          style: textTheme.titleMedium!.copyWith(
            color: Palette.purple2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      separatorBuilder: (context, index) => const Divider(
        height: 8,
        indent: 16,
        endIndent: 16,
      ),
      itemCount: scores.length,
    );
  }
}

class ScoreRecapDetailPageArgs {
  final String practicumId;
  final String? username;

  const ScoreRecapDetailPageArgs({
    required this.practicumId,
    this.username,
  });
}
