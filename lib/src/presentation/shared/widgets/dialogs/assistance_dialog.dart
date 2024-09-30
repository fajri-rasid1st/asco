// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/datetime_extension.dart';
import 'package:asco/core/extensions/string_extension.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/assistances/assistance_post.dart';
import 'package:asco/src/data/models/control_cards/control_card.dart';
import 'package:asco/src/presentation/features/assistant/assistance/providers/update_assistance_provider.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/custom_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';

class AssistanceDialog extends ConsumerWidget {
  final int number;
  final int dueDate;
  final ControlCard card;

  const AssistanceDialog({
    super.key,
    required this.number,
    required this.dueDate,
    required this.card,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();
    final assistance = number == 1 ? card.firstAssistance! : card.secondAssistance!;

    DateTime? assistanceDate;

    return CustomDialog(
      title: 'Asistensi $number',
      onPressedPrimaryAction: () => submit(context, ref, formKey, assistance.id!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${card.student?.username}',
            style: textTheme.bodyMedium!.copyWith(
              color: Palette.purple3,
            ),
          ),
          Text(
            '${card.student?.fullname}',
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
                  initialValue: assistance.date == 0
                      ? DateTime.now().toIso8601String()
                      : DateTime.fromMillisecondsSinceEpoch(assistance.date! * 1000)
                          .toIso8601String(),
                  prefixIconName: 'calendar_month_outlined.svg',
                  suffixIconName: 'close_outlined.svg',
                  textInputType: TextInputType.none,
                  onTap: () async {
                    final date = await context.showCustomDatePicker(
                      initialdate: assistanceDate ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 120)),
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
                CustomTextField(
                  name: 'note',
                  label: 'Catatan',
                  initialValue: assistance.note,
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

  void submit(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormBuilderState> formKey,
    String assistanceId,
  ) {
    if (DateTime.now().secondsSinceEpoch < dueDate) {
      FocusManager.instance.primaryFocus?.unfocus();

      formKey.currentState?.save();

      final value = formKey.currentState!.value;

      final status = value['date'] != null;
      final date = status ? (value['date'] as String).toSecondsSinceEpoch() : 0;
      final note = value['note'];

      final assistance = AssistancePost(
        status: status,
        date: date,
        note: note,
      );

      ref.read(updateAssistanceProvider.notifier).updateAssistance(assistanceId, assistance);
    } else {
      context.showSnackBar(
        title: 'Asistensi Telah Selesai',
        message: 'Batas waktu asistensi untuk pertemuan ini telah dilewati.',
        type: SnackBarType.error,
      );

      navigatorKey.currentState!.pop();
    }
  }
}
