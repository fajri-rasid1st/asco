// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:percent_indicator/circular_percent_indicator.dart';

// Project imports:
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class StudentMeetingDetailPage extends StatelessWidget {
  const StudentMeetingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pertemuan 1',
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                color: Palette.purple2,
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    RotatedBox(
                      quarterTurns: -2,
                      child: SvgAsset(
                        AssetPath.getVector('bg_attribute.svg'),
                        width: AppSize.getAppWidth(context) / 2,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Text(
                            'Tipe Data dan Attribute',
                            style: textTheme.headlineSmall!.copyWith(
                              color: Palette.background,
                            ),
                          ),
                        ),
                        const MentorListTile(
                          name: 'Muhammad Fajri Rasid',
                          role: 'Pemateri',
                          imageUrl: 'https://placehold.co/100x100/png',
                        ),
                        const MentorListTile(
                          name: 'Wd. Ananda Lesmono',
                          role: 'Pendamping',
                          imageUrl: 'https://placehold.co/100x100/png',
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverAppBar(
              elevation: 0,
              pinned: true,
              automaticallyImplyLeading: false,
              toolbarHeight: 6,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Palette.violet2,
                      Palette.violet4,
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.menu_book_rounded),
                label: const Text('Buka Modul'),
                style: FilledButton.styleFrom(
                  foregroundColor: Palette.purple2,
                  backgroundColor: Palette.background,
                ),
              ).fullWidth(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                decoration: BoxDecoration(
                  color: Palette.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(text: 'Status Pertemuan'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Palette.purple4,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Selesai',
                          style: textTheme.labelLarge!.copyWith(
                            color: Palette.purple2,
                          ),
                        ),
                      ),
                    ),
                    const SectionTitle(text: 'Status Absensi'),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Palette.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Palette.purple2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(3, 4),
                            color: Palette.purple2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Palette.purple3,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check_rounded,
                                  color: Palette.background,
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hadir',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleSmall!.copyWith(
                                      color: Palette.purple2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    'Waktu absensi 10:15',
                                    style: textTheme.bodySmall!.copyWith(
                                      color: Palette.secondaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '(Terlambat 5 menit)',
                                    style: textTheme.labelSmall!.copyWith(
                                      color: Palette.errorText,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  ScoreIndicator(
                    title: 'Nilai Quiz',
                    score: 78.0,
                    poinPlus: 15,
                  ),
                  SizedBox(width: 16),
                  ScoreIndicator(
                    title: 'Nilai Respon',
                    score: 89.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MentorListTile extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;

  const MentorListTile({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 12,
      leading: CircleNetworkImage(
        imageUrl: imageUrl,
        size: 40,
      ),
      title: Text(
        name,
        style: textTheme.titleSmall!.copyWith(
          color: Palette.background,
        ),
      ),
      subtitle: Text(
        role,
        style: textTheme.bodySmall!.copyWith(
          color: Palette.scaffoldBackground,
        ),
      ),
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 6,
      ),
      child: Text(
        text,
        style: textTheme.titleMedium!.copyWith(
          color: Palette.purple2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ScoreIndicator extends StatelessWidget {
  final String title;
  final double score;
  final int? poinPlus;

  const ScoreIndicator({
    super.key,
    required this.title,
    required this.score,
    this.poinPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        decoration: BoxDecoration(
          color: Palette.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            SectionTitle(text: title),
            const SizedBox(height: 4),
            Stack(
              alignment: Alignment.topRight,
              children: [
                CircularPercentIndicator(
                  percent: score / 100,
                  animation: true,
                  animationDuration: 1000,
                  curve: Curves.easeOut,
                  radius: 55,
                  lineWidth: 10,
                  progressColor: Palette.purple3,
                  backgroundColor: Colors.transparent,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Container(
                    width: 91,
                    height: 91,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Palette.purple2,
                    ),
                    child: Center(
                      child: Text(
                        '$score',
                        style: textTheme.headlineSmall!.copyWith(
                          color: Palette.background,
                        ),
                      ),
                    ),
                  ),
                ),
                if (poinPlus != null)
                  CircleBorderContainer(
                    size: 32,
                    borderColor: const Color(0xFFE3B640),
                    fillColor: const Color(0xFFF2CF74),
                    child: Text(
                      '+$poinPlus',
                      style: textTheme.bodySmall!.copyWith(
                        color: Palette.background,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
