// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:percent_indicator/circular_percent_indicator.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/practicum_assignment_score_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';

class AssistantAssistanceScorePage extends StatelessWidget {
  const AssistantAssistanceScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Nilai Tugas Praktikum',
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) => AssistanceScoreCard(
          rate: 5,
          value: 85.0,
          statusBadgeText: index % 2 == 1 ? 'Tepat Waktu' : 'Terlambat',
          statusBadgeColor: index % 2 == 1 ? Palette.purple3 : Palette.pink2,
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemCount: 10,
      ),
    );
  }
}

class AssistanceScoreCard extends StatelessWidget {
  final int rate;
  final double value;
  final String statusBadgeText;
  final Color statusBadgeColor;

  const AssistanceScoreCard({
    super.key,
    required this.rate,
    required this.value,
    required this.statusBadgeText,
    required this.statusBadgeColor,
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
        builder: (context) => const PracticumAssignmentScoreDialog(meetingNumber: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'H071191051',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.purple3,
                  ),
                ),
                Text(
                  'Wd. Ananda Lesmono',
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
                  'Waktu Asistensi 1 & 2',
                  style: textTheme.labelSmall,
                ),
                const SizedBox(height: 4),
                CustomBadge(
                  color: statusBadgeColor.withOpacity(.2),
                  text: statusBadgeText,
                  textStyle: textTheme.labelSmall!.copyWith(
                    color: statusBadgeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                CustomBadge(
                  color: statusBadgeColor.withOpacity(.2),
                  text: statusBadgeText,
                  textStyle: textTheme.labelSmall!.copyWith(
                    color: statusBadgeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          CircularPercentIndicator(
            percent: value / 100,
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
                  '$rate',
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
}
