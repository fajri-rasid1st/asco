// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
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

    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay.now();

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
            const SizedBox(height: 12),
            CustomDropdownField(
              name: 'meetingDay',
              label: 'Setiap Hari',
              isSmall: true,
              items: dayOfWeek.keys.toList(),
              values: dayOfWeek.values.toList(),
              initialValue: dayOfWeek.keys.first,
              onChanged: (_) {},
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    name: 'startTime',
                    label: 'Waktu Mulai',
                    isSmall: true,
                    initialValue: startTime.format(context),
                    textInputType: TextInputType.none,
                    onTap: () async {
                      final time = await context.showCustomTimePicker(
                        initialTime: startTime,
                        formKey: formKey,
                        fieldKey: 'startTime',
                        helpText: 'Masukkan waktu kelas dimulai',
                      );

                      if (time != null) startTime = time;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    name: 'endTime',
                    label: 'Waktu Selesai',
                    isSmall: true,
                    initialValue: endTime.format(context),
                    textInputType: TextInputType.none,
                    onTap: () async {
                      final time = await context.showCustomTimePicker(
                        initialTime: endTime,
                        formKey: formKey,
                        fieldKey: 'endTime',
                        helpText: 'Masukkan waktu kelas selesai',
                      );

                      if (time != null) endTime = time;
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

  void submit(GlobalKey<FormBuilderState> formKey) {
    if (onSubmitted != null) {
      FocusManager.instance.primaryFocus?.unfocus();

      if (formKey.currentState!.saveAndValidate()) {
        onSubmitted!(formKey.currentState!.value);
      }
    }
  }
}
