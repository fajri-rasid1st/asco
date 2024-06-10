// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:percent_indicator/circular_percent_indicator.dart';

// Project imports:
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';

class ScoreDetailPage extends StatelessWidget {
  const ScoreDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const scoreRecapList = [
      ScoreRecap(
        title: 'NILAI UJIAN LAB',
        value: 85.6,
        color: Palette.orange1,
        backgroundColor: Palette.orange3,
      ),
      ScoreRecap(
        title: 'NILAI ASISTENSI',
        value: 90.0,
        color: Palette.purple3,
        backgroundColor: Palette.purple5,
      ),
      ScoreRecap(
        title: 'NILAI QUIZ',
        value: 78.5,
        color: Palette.violet1,
        backgroundColor: Palette.violet5,
      ),
      ScoreRecap(
        title: 'NILAI RESPON',
        value: 95.8,
        color: Palette.info,
        backgroundColor: Color(0xFFE3EBFF),
      ),
    ];

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Wd. Ananda Lesmono',
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Nilai Akhir',
                    style: textTheme.titleMedium?.copyWith(
                      color: Palette.purple2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CircularPercentIndicator(
                    percent: .86,
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
                          'A',
                          style: textTheme.displaySmall?.copyWith(
                            color: Palette.purple2,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '86.0',
                            style: textTheme.titleMedium?.copyWith(
                              color: Palette.purple2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: scoreRecapList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 16 / 9,
                    ),
                    itemBuilder: (context, index) {
                      return ScoreRecapCard(
                        recap: scoreRecapList[index],
                      );
                    },
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
                    labelStyle: textTheme.titleMedium?.copyWith(
                      color: Palette.purple2,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: textTheme.bodyLarge?.copyWith(
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
                    child: const TabBarView(
                      children: [
                        MeetingScoreList(totalMeetings: 10),
                        MeetingScoreList(totalMeetings: 10),
                        MeetingScoreList(totalMeetings: 10),
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
  }
}

class ScoreRecapCard extends StatelessWidget {
  final ScoreRecap recap;

  const ScoreRecapCard({super.key, required this.recap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: recap.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recap.title,
            style: textTheme.bodyMedium?.copyWith(
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
                  color: recap.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  '${recap.value}',
                  style: textTheme.titleLarge?.copyWith(
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
  final int totalMeetings;

  const MeetingScoreList({super.key, required this.totalMeetings});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
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
                '${index + 1}',
                style: textTheme.titleMedium?.copyWith(
                  color: Palette.background,
                  height: 1,
                ),
              ),
            ),
          ),
          title: Text(
            'Tipe Data dan Attribute',
            style: textTheme.bodyMedium?.copyWith(
              color: Palette.purple3,
            ),
          ),
          subtitle: Text(
            '80.0',
            style: textTheme.titleMedium?.copyWith(
              color: Palette.purple2,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 8,
          indent: 16,
          endIndent: 16,
        );
      },
      itemCount: totalMeetings,
    );
  }
}

class ScoreRecap {
  final String title;
  final double value;
  final Color color;
  final Color backgroundColor;

  const ScoreRecap({
    required this.title,
    required this.value,
    required this.color,
    required this.backgroundColor,
  });
}
