// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/lab_rule_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';

class LabRulesPage extends StatelessWidget {
  const LabRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Tata Tertib Lab',
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: FileUploadField(
                  name: 'labRulePath',
                  label: 'Tata Tertib Lab',
                  labelStyle: textTheme.titleLarge!.copyWith(
                    color: Palette.purple2,
                    fontWeight: FontWeight.w600,
                  ),
                  extensions: const ['pdf', 'doc', 'docx'],
                  onChanged: (value) => debugPrint(value),
                ),
              ),
              const SectionHeader(
                title: 'Sanksi Nilai Asistensi',
                padding: EdgeInsets.fromLTRB(20, 16, 0, 0),
              ),
              const LabRuleListTile(
                title: 'Terlambat asistensi <1 minggu',
                subtitle: 'Pengurangan nilai 5 poin',
                fieldName: 'assistanceDelayMinimumPoints',
                attendanceType: AttendanceType.assistance,
              ),
              const LabRuleListTile(
                title: 'Terlambat asistensi ≥1 minggu',
                subtitle: 'Pengurangan nilai 10 poin',
                fieldName: 'assistanceDelayMaximumPoints',
                attendanceType: AttendanceType.assistance,
              ),
              const SectionHeader(
                title: 'Sanksi Nilai Quiz',
                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              ),
              const LabRuleListTile(
                title: 'Terlambat absensi ≥20 menit',
                subtitle: 'Pengurangan nilai 5 poin',
                fieldName: 'attendanceDelayMinimumPoints',
                attendanceType: AttendanceType.meeting,
              ),
              const LabRuleListTile(
                title: 'Terlambat absensi ≥30 menit',
                subtitle: 'Pengurangan nilai 10 poin',
                fieldName: 'attendanceDelayMaximumPoints',
                attendanceType: AttendanceType.meeting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LabRuleListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String fieldName;
  final AttendanceType attendanceType;

  const LabRuleListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fieldName,
    required this.attendanceType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          titleTextStyle: textTheme.titleMedium!.copyWith(
            color: Palette.purple2,
            fontWeight: FontWeight.w600,
          ),
          subtitle: Text(subtitle),
          subtitleTextStyle: textTheme.bodySmall!.copyWith(
            color: Palette.secondaryText,
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: Palette.purple2,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          onTap: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => LabRuleDialog(
              title: attendanceType == AttendanceType.assistance ? 'Sanksi Nilai Asistensi' : 'Sanksi Nilai Quiz',
              subtitle: title,
              fieldName: fieldName,
            ),
          ),
        ),
        const Divider(
          height: 1,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}
