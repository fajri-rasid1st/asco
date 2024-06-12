// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
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
                  extensions: const ['pdf', 'doc', 'docx'],
                  onChanged: (value) => debugPrint(value),
                  validator: FormBuilderValidators.required(),
                ),
              ),
              const SectionHeader(
                title: 'Sanksi Nilai Asistensi',
                padding: EdgeInsets.fromLTRB(20, 16, 0, 0),
              ),
              const LabRuleListTile(
                title: 'Terlambat asistensi <1 minggu',
                subtitle: 'Pengurangan nilai 5 poin',
              ),
              const LabRuleListTile(
                title: 'Terlambat asistensi ≥1 minggu',
                subtitle: 'Pengurangan nilai 10 poin',
              ),
              const SectionHeader(
                title: 'Sanksi Nilai Quiz',
                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              ),
              const LabRuleListTile(
                title: 'Terlambat absensi >15 menit',
                subtitle: 'Pengurangan nilai 5 poin',
              ),
              const LabRuleListTile(
                title: 'Terlambat absensi ≥30 menit',
                subtitle: 'Pengurangan nilai 10 poin',
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

  const LabRuleListTile({
    super.key,
    required this.title,
    required this.subtitle,
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
            builder: (context) => const LabRuleDialog(fieldName: 'assistanceDelayMinimumPoints'),
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
