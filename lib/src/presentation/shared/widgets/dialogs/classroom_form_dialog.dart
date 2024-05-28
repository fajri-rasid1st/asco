// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Project imports:
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/custom_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_dropdown_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';

class ClassroomFormDialog extends StatelessWidget {
  final void Function(Map<String, dynamic> value)? onSubmitted;

  const ClassroomFormDialog({super.key, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    TimeOfDay? startTime;
    TimeOfDay? endTime;

    return CustomDialog(
      title: 'Tambah Kelas',
      onPressedPrimaryAction: () => submit(formKey),
      child: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              name: 'name',
              label: 'Kelas (auto-generated)',
              isSmall: true,
              enabled: false,
              initialValue: FunctionHelper.nextLetter('B'),
            ),
            const SizedBox(height: 16),
            CustomDropdownField(
              name: 'meetingDay',
              label: 'Setiap Hari',
              isSmall: true,
              items: dayOfWeek.values.toList(),
              values: dayOfWeek.keys.toList(),
              initialValue: dayOfWeek.keys.first,
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    name: 'startTime',
                    label: 'Waktu Mulai',
                    isSmall: true,
                    textInputType: TextInputType.none,
                    onTap: () async {
                      startTime = await showClassroomTimePicker(
                        context: context,
                        formKey: formKey,
                        fieldKey: 'startTime',
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomTextField(
                    name: 'endTime',
                    label: 'Waktu Selesai',
                    isSmall: true,
                    textInputType: TextInputType.none,
                    onTap: () async {
                      endTime = await showClassroomTimePicker(
                        context: context,
                        formKey: formKey,
                        fieldKey: 'startTime',
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<TimeOfDay?> showClassroomTimePicker({
    required BuildContext context,
    required GlobalKey<FormBuilderState> formKey,
    required String fieldKey,
  }) async {
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: 'Masukkan Waktu',
      cancelText: 'Kembali',
      confirmText: 'Konfirmasi',
      errorInvalidText: 'Masukkan waktu yang valid',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (timeOfDay != null) {
      formKey.currentState!.fields[fieldKey]!.didChange(timeOfDay.toString());
    }

    return timeOfDay;
  }

  void submit(GlobalKey<FormBuilderState> formKey) {
    if (onSubmitted != null) {
      FocusManager.instance.primaryFocus?.unfocus();

      if (formKey.currentState!.saveAndValidate()) {
        onSubmitted!(formKey.currentState!.value);
      }
    }
  }
}
