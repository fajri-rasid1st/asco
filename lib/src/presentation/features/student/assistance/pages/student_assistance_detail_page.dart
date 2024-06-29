// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:percent_indicator/linear_percent_indicator.dart';

// Project imports:
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class StudentAssistanceDetailPage extends StatelessWidget {
  const StudentAssistanceDetailPage({super.key});

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
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Tipe Data dan Attribute',
                              style: textTheme.headlineSmall!.copyWith(
                                color: Palette.background,
                              ),
                            ),
                          ),
                        ],
                      ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.menu_book_rounded),
                      label: const Text('Lihat Soal Praktikum'),
                      style: FilledButton.styleFrom(
                        foregroundColor: Palette.purple2,
                        backgroundColor: Palette.background,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.file_download_outlined,
                      color: Palette.purple2,
                    ),
                    tooltip: 'Download Soal Praktikum',
                    style: IconButton.styleFrom(
                      foregroundColor: Palette.purple2,
                      backgroundColor: Palette.background,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SectionTitle(text: 'Batas Waktu Asistensi'),
              LinearPercentIndicator(
                percent: .78,
                animation: true,
                animationDuration: 1000,
                curve: Curves.easeOut,
                padding: EdgeInsets.zero,
                lineHeight: 24,
                barRadius: const Radius.circular(12),
                backgroundColor: Palette.background,
                linearGradient: const LinearGradient(
                  colors: [
                    Palette.purple3,
                    Palette.purple2,
                  ],
                ),
                clipLinearGradient: true,
                widgetIndicator: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 14, right: 45),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Palette.background,
                  ),
                  child: const Icon(
                    Icons.schedule_rounded,
                    color: Palette.purple2,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Deadline: 10 April',
                  style: textTheme.labelSmall!.copyWith(
                    color: Palette.pink1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SectionTitle(text: 'Absen Asistensi'),
              const AttendanceAssistanceCard(
                number: 1,
                date: '26 Februari 2024',
                notes: 'Tidak ada catatan',
                statusBadgeText: 'Tepat Waktu',
                statusBadgeColor: Palette.purple3,
              ),
              const SizedBox(height: 16),
              const AttendanceAssistanceCard(
                number: 2,
                date: '1 Maret 2024',
                notes: 'Minimal bawa makanan lah',
                statusBadgeText: 'Terlambat',
                statusBadgeColor: Palette.pink2,
              ),
            ],
          ),
        ),
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
        top: 20,
        bottom: 6,
      ),
      child: Text(
        text,
        style: textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }
}

class AttendanceAssistanceCard extends StatelessWidget {
  final int number;
  final String date;
  final String statusBadgeText;
  final Color statusBadgeColor;
  final String notes;

  const AttendanceAssistanceCard({
    super.key,
    required this.number,
    required this.date,
    required this.statusBadgeText,
    required this.statusBadgeColor,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Palette.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asistensi $number',
                        style: textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        date,
                        style: textTheme.bodySmall!.copyWith(
                          color: Palette.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
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
        ),
        Container(
          width: AppSize.getAppWidth(context) - 56,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          decoration: const BoxDecoration(
            color: Palette.purple2,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Catatan',
                style: textTheme.bodyMedium!.copyWith(
                  color: Palette.background,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                notes,
                style: textTheme.bodySmall!.copyWith(
                  color: Palette.scaffoldBackground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
