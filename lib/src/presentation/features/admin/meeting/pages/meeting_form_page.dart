// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/string_extension.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/meetings/meeting_post.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_dropdown_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';

class MeetingFormPage extends StatelessWidget {
  final MeetingFormPageArgs args;

  const MeetingFormPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    var meetingDate = args.meeting?.date != null
        ? DateTime.fromMillisecondsSinceEpoch((args.meeting!.date! * 1000).truncate())
        : DateTime.now();

    return Scaffold(
      appBar: CustomAppBar(
        title: '${args.meeting != null ? 'Edit' : 'Tambah'} Pertemuan',
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
              CustomTextField(
                name: 'number',
                label: 'Pertemuan (auto-generated)',
                enabled: false,
                initialValue: '${args.meeting?.number ?? args.meetingNumber}',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                name: 'lesson',
                label: 'Nama Materi',
                hintText: 'Masukkan nama materi',
                initialValue: args.meeting?.lesson,
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
                initialValue: DateFormat('d MMMM yyyy', 'id_ID').format(meetingDate),
                prefixIconName: 'calendar_month_outlined.svg',
                textInputType: TextInputType.none,
                onTap: () async {
                  final date = await context.showCustomDatePicker(
                    initialdate: meetingDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 180)),
                    formKey: formKey,
                    fieldKey: 'date',
                    helpText: 'Tanggal Pertemuan',
                  );

                  if (date != null) meetingDate = date;
                },
              ),
              const SizedBox(height: 12),
              CustomDropdownField(
                name: 'assistantId',
                label: 'Pemateri',
                items: args.assistants.map((e) => '${e.fullname} (${e.classOf})').toList(),
                values: args.assistants.map((e) => e.id).toList(),
                initialValue: args.meeting?.assistant?.id ??
                    (args.assistants.isNotEmpty ? args.assistants.first.id : null),
              ),
              const SizedBox(height: 12),
              CustomDropdownField(
                name: 'coAssistantId',
                label: 'Pendamping',
                items: args.assistants.map((e) => '${e.fullname} (${e.classOf})').toList(),
                values: args.assistants.map((e) => e.id).toList(),
                initialValue: args.meeting?.coAssistant?.id ??
                    (args.assistants.isNotEmpty ? args.assistants.last.id : null),
              ),
              const SizedBox(height: 12),
              const FileUploadField(
                name: 'modulePath',
                label: 'Modul',
                extensions: ['pdf', 'doc', 'docx'],
              ),
              const SizedBox(height: 12),
              const FileUploadField(
                name: 'assignmentPath',
                label: 'Soal praktikum',
                extensions: ['pdf', 'doc', 'docx'],
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
      final meeting = MeetingPost(
        number: int.parse(formKey.currentState!.value['number']),
        lesson: formKey.currentState!.value['lesson'],
        date: (formKey.currentState!.value['date'] as String).toSecondsSinceEpoch(),
        assistantId: formKey.currentState!.value['assistantId'],
        coAssistantId: formKey.currentState!.value['coAssistantId'],
        modulePath: formKey.currentState!.value['modulePath'],
        assignmentPath: formKey.currentState!.value['assignmentPath'],
      );

      print(meeting);
    }
  }
}

class MeetingFormPageArgs {
  final Meeting? meeting;
  final int? meetingNumber;
  final List<Profile> assistants;

  const MeetingFormPageArgs({
    this.meeting,
    this.meetingNumber,
    required this.assistants,
  });
}
