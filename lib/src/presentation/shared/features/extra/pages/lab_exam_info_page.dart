// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';

// Project imports:
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/themes/light_theme.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/features/assistant/extra/pages/edit_extra_page.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';

class LabExamInfoPage extends StatelessWidget {
  const LabExamInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Informasi Ujian Lab',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (roleId == 2) ...[
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => navigatorKey.currentState!.pushNamed(
                        editExtraRoute,
                        arguments: const EditExtraPageArgs(
                          title: 'Info Ujian Lab',
                          fieldName: 'labExamInfo',
                          fieldLabel: 'Info Ujian Lab',
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Palette.error,
                      ),
                      child: const Text('Edit Info'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Palette.success,
                      ),
                      child: const Text('Input Nilai'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
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
                  border: Border.all(
                    color: Palette.border,
                  ),
                ),
                child: MarkdownBody(
                  data: '## Lorem Ipsum',
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
