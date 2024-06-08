// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/datetime_extension.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_dropdown_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';

class MeetingFormPage extends StatelessWidget {
  final MeetingFormPageArgs args;

  const MeetingFormPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    var meetingDate = DateTime.now();

    const assistants = [
      'Fajri - 2019',
      'Ikhsan - 2019',
      'Richard - 2019',
      'Ananda - 2021',
      'Erwin - 2021',
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: '${args.action} Pertemuan',
        action: IconButton(
          onPressed: createOrEditMeeting,
          icon: const Icon(Icons.check_rounded),
          tooltip: 'Submit',
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              const CustomTextField(
                name: 'number',
                label: 'No. Pertemuan (auto-generated)',
                enabled: false,
                initialValue: '11',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                name: 'lesson',
                label: 'Nama Materi',
                hintText: 'Masukkan nama materi',
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Field wajib diisi',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextField(
                name: 'date',
                label: 'Tanggal Pertemuan',
                initialValue: meetingDate.toStringPattern('d MMMM yyyy'),
                prefixIconName: 'calendar_month_outlined.svg',
                textInputType: TextInputType.none,
                onTap: () async {
                  final date = await context.showCustomDatePicker(
                    initialdate: meetingDate,
                    formKey: formKey,
                    fieldKey: 'date',
                    helpText: 'Tanggal Pertemuan',
                  );

                  if (date != null) meetingDate = date;
                },
              ),
              const SizedBox(height: 12),
              CustomDropdownField(
                name: 'assistant1Id',
                label: 'Pemateri',
                items: assistants,
                values: assistants,
                initialValue: assistants.first,
              ),
              const SizedBox(height: 12),
              CustomDropdownField(
                name: 'assistant2Id',
                label: 'Pendamping',
                items: assistants,
                values: assistants,
                initialValue: assistants.last,
              ),
              const SizedBox(height: 12),
              FileUploadField(
                name: 'modulePath',
                label: 'Modul',
                extensions: const ['pdf', 'doc', 'docx'],
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 12),
              FileUploadField(
                name: 'assignmentPath',
                label: 'Soal praktikum',
                extensions: const ['pdf', 'doc', 'docx'],
                validator: FormBuilderValidators.required(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createOrEditMeeting() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      debugPrint(formKey.currentState!.value.toString());

      navigatorKey.currentState!.pop();
    }
  }
}

class MeetingFormPageArgs {
  final String action;

  const MeetingFormPageArgs({required this.action});
}
