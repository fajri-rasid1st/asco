// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';

// Project imports:
import 'package:asco/core/enums/extra_type.dart';
import 'package:asco/core/enums/score_type.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/themes/light_theme.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/assistant/extra/pages/edit_extra_page.dart';
import 'package:asco/src/presentation/shared/features/score/pages/score_input_page.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class LabExamInfoPage extends StatelessWidget {
  const LabExamInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Ujian Lab',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (MapHelper.getRoleId(CredentialSaver.credential?.role) == 2) ...[
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => navigatorKey.currentState!.pushNamed(
                        editExtraRoute,
                        arguments: const EditExtraPageArgs(
                          type: ExtraType.labExam,
                          title: 'Info Ujian Lab',
                          fieldName: 'labExamInfo',
                          fieldLabel: 'Info Ujian Lab',
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Palette.secondary,
                      ),
                      child: const Text('Edit Info'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => navigatorKey.currentState!.pushNamed(
                        scoreInputRoute,
                        arguments: const ScoreInputPageArgs(scoreType: ScoreType.exam),
                      ),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text('Input Nilai'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Palette.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  SvgAsset(
                    AssetPath.getVector('bg_attribute_3.svg'),
                    height: 44,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        const PracticumBadgeImage(
                          badgeUrl: 'https://placehold.co/138x150/png',
                          width: 48,
                          height: 52,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Informasi Ujian Lab',
                                style: textTheme.bodySmall!.copyWith(
                                  color: Palette.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Pemrograman Mobile',
                                style: textTheme.titleMedium,
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
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: double.infinity,
                minHeight: AppSize.getAppWidth(context) - 60,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Palette.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MarkdownBody(
                  data: '_Lorem ipsum_',
                  selectable: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(lightTheme),
                  onTapLink: (text, href, title) {
                    if (href != null) FunctionHelper.openUrl(href);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
