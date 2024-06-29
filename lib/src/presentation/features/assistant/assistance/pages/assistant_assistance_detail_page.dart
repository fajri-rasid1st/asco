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
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AssistantAssistanceDetailPage extends StatelessWidget {
  const AssistantAssistanceDetailPage({super.key});

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
              FileUploadField(
                name: 'assignmentPath',
                label: 'Soal Praktikum',
                labelStyle: textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                extensions: const ['pdf', 'doc', 'docx'],
                onChanged: (value) => debugPrint(value),
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
              const SectionTitle(text: 'Nilai Tugas Praktikum'),
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
