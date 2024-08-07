// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/custom_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';

class AssistanceDialog extends StatelessWidget {
  final int assistanceNumber;

  const AssistanceDialog({super.key, required this.assistanceNumber});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    DateTime? assistanceDate;

    return CustomDialog(
      title: 'Asistensi $assistanceNumber',
      onPressedPrimaryAction: () => submit(formKey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'H071211074',
            style: textTheme.bodyMedium!.copyWith(
              color: Palette.purple3,
            ),
          ),
          Text(
            'Wd. Ananda Lesmono',
            style: textTheme.titleLarge!.copyWith(
              color: Palette.purple2,
            ),
          ),
          const SizedBox(height: 8),
          FormBuilder(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  name: 'date',
                  label: 'Tanggal Asistensi',
                  isSmall: true,
                  initialValue: DateTime.now().toIso8601String(),
                  prefixIconName: 'calendar_month_outlined.svg',
                  suffixIconName: 'close_outlined.svg',
                  textInputType: TextInputType.none,
                  onTap: () async {
                    final date = await context.showCustomDatePicker(
                      initialdate: assistanceDate ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 180)),
                      lastDate: DateTime.now(),
                      formKey: formKey,
                      fieldKey: 'date',
                      helpText: 'Tanggal Asistensi',
                    );

                    if (date != null) assistanceDate = date;
                  },
                  onSuffixIconTap: () {
                    assistanceDate = null;

                    formKey.currentState!.fields['date']!.didChange(null);
                  },
                ),
                const SizedBox(height: 12),
                const CustomTextField(
                  name: 'note',
                  label: 'Catatan',
                  isSmall: true,
                  hintText: 'Tambahkan catatan',
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Text(
              'Note: kosongkan tanggal untuk membatalkan asistensi.',
              style: textTheme.bodySmall!.copyWith(
                color: Palette.errorText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submit(GlobalKey<FormBuilderState> formKey) {
    FocusManager.instance.primaryFocus?.unfocus();

    formKey.currentState!.save();

    // Update attendance assistance here ...

    navigatorKey.currentState!.pop<bool>(formKey.currentState!.value['date'] != null);
  }
}
