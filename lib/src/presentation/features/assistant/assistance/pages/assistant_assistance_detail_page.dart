// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Project imports:
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/app_size.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/assistance_status_icon.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';
import 'package:asco/src/presentation/shared/widgets/section_title.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class AssistantAssistanceDetailPage extends StatelessWidget {
  const AssistantAssistanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    var deadlineDate = DateTime.now().add(const Duration(days: 7));

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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                        Text(
                          'Deadline: 10 April',
                          style: textTheme.labelSmall!.copyWith(
                            color: Palette.pink1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  FormBuilder(
                    key: formKey,
                    child: IconButton(
                      onPressed: () => updateAssistanceDeadline(context, deadlineDate),
                      icon: const Icon(
                        Icons.edit_calendar_outlined,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Palette.violet3,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
              const SectionTitle(text: 'Nilai Tugas Praktikum'),
              FilledButton(
                onPressed: () => navigatorKey.currentState!.pushNamed(
                  assistantAssistanceScoreRoute,
                ),
                style: FilledButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Input Nilai'),
              ).fullWidth(),
              const SectionTitle(text: 'Asistensi'),
              ...List<Padding>.generate(
                10,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index == 9 ? 0 : 10,
                  ),
                  child: UserCard(
                    user: CredentialSaver.credential!,
                    badgeText: 'Kelas A',
                    trailing: Row(
                      children: [
                        const SizedBox(width: 8),
                        AssistanceStatusIcon(
                          isAttend: true,
                          onTap: () => showAssistanceDialog(
                            context,
                            assistanceNumber: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        AssistanceStatusIcon(
                          isAttend: false,
                          onTap: () => showAssistanceDialog(
                            context,
                            assistanceNumber: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showAssistanceDialog(
    BuildContext context, {
    required int assistanceNumber,
  }) async {
    // final isAttend = await showDialog<bool?>(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => AssistanceDialog(assistanceNumber: assistanceNumber),
    // );

    // if (!context.mounted) return;

    // if (isAttend != null) {
    //   Timer? timer = Timer(
    //     const Duration(seconds: 3),
    //     () => navigatorKey.currentState!.pop(),
    //   );

    //   showDialog(
    //     context: context,
    //     builder: (context) => AttendanceStatusDialog(
    //       attendanceType: AttendanceType.assistance,
    //       isAttend: isAttend,
    //     ),
    //   ).then((_) {
    //     timer?.cancel();
    //     timer = null;
    //   });
    // }
  }

  void updateAssistanceDeadline(BuildContext context, DateTime deadlineDate) async {
    final date = await context.showCustomDatePicker(
      initialdate: deadlineDate,
      firstDate: DateTime.now(),
      lastDate: deadlineDate.add(const Duration(days: 180)),
      formKey: formKey,
      fieldKey: 'assistanceDeadline',
    );

    if (date != null) debugPrint(date.toString());
  }
}
