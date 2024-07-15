// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/extensions/string_extension.dart';
import 'package:asco/core/helpers/function_helper.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/custom_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_dropdown_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';

class ClassroomFormDialog extends StatelessWidget {
  final Classroom? classroom;
  final String? lastClassroomName;

  const ClassroomFormDialog({
    super.key,
    this.classroom,
    this.lastClassroomName,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    var startTime = TimeOfDay.now();
    var endTime = TimeOfDay.now();

    return CustomDialog(
      title: '${classroom != null ? 'Edit' : 'Tambah'} Kelas',
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
              initialValue: classroom?.name ?? FunctionHelper.nextLetter(lastClassroomName ?? 'Z'),
            ),
            const SizedBox(height: 12),
            CustomDropdownField(
              name: 'meetingDay',
              label: 'Setiap Hari',
              isSmall: true,
              items: dayOfWeek.keys.toList(),
              values: dayOfWeek.values.toList(),
              initialValue: classroom?.meetingDay ?? dayOfWeek.values.first,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    name: 'startTime',
                    label: 'Waktu Mulai',
                    isSmall: true,
                    initialValue:
                        classroom?.startTime?.to24TimeFormat() ?? startTime.format(context),
                    textInputType: TextInputType.none,
                    onTap: () async {
                      final time = await context.showCustomTimePicker(
                        initialTime: startTime,
                        formKey: formKey,
                        fieldKey: 'startTime',
                        helpText: 'Waktu Kelas Dimulai',
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
                    initialValue: classroom?.endTime?.to24TimeFormat() ?? endTime.format(context),
                    textInputType: TextInputType.none,
                    onTap: () async {
                      final time = await context.showCustomTimePicker(
                        initialTime: endTime,
                        formKey: formKey,
                        fieldKey: 'endTime',
                        helpText: 'Waktu Kelas Selesai',
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
    FocusManager.instance.primaryFocus?.unfocus();

    formKey.currentState!.save();

    final classroom = Classroom(
      name: formKey.currentState!.value['name'],
      meetingDay: formKey.currentState!.value['meetingDay'],
      startTime: (formKey.currentState!.value['startTime'] as String).to24TimeFormat(),
      endTime: (formKey.currentState!.value['endTime'] as String).to24TimeFormat(),
    );

    navigatorKey.currentState!.pop(classroom);
  }
}
