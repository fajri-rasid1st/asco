// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/string_extension.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/meetings/meeting_post.dart';
import 'package:asco/src/presentation/features/admin/meeting/providers/meeting_actions_provider.dart';
import 'package:asco/src/presentation/features/admin/user/providers/users_provider.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_dropdown_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';
import 'package:asco/src/presentation/shared/widgets/loading_indicator.dart';

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
        action: Consumer(
          builder: (context, ref, child) {
            return IconButton(
              onPressed: () => createOrEditMeeting(context, ref),
              icon: const Icon(Icons.check_rounded),
              tooltip: 'Submit',
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: const CircleBorder(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: FormBuilder(
          key: formKey,
          child: Consumer(
            builder: (context, ref, child) {
              final assistants = ref.watch(
                UsersProvider(
                  role: 'ASSISTANT',
                  practicum: args.practicumId,
                ),
              );

              ref.listen(
                UsersProvider(
                  role: 'ASSISTANT',
                  practicum: args.practicumId,
                ),
                (_, state) {
                  state.whenOrNull(
                    error: (error, _) {
                      if ('$error' == kNoInternetConnection) {
                        context.showNoConnectionSnackBar();
                      } else {
                        context.showSnackBar(
                          title: 'Terjadi Kesalahan',
                          message: '$error',
                          type: SnackBarType.error,
                        );
                      }
                    },
                  );
                },
              );

              return assistants.when(
                loading: () => const LoadingIndicator(),
                error: (_, __) => const SizedBox(),
                data: (assistants) {
                  if (assistants == null) return const SizedBox();

                  return Column(
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
                        initialValue: DateFormat('d/M/yyyy').format(meetingDate),
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
                        items: assistants.map((e) => '${e.nickname} (${e.classOf})').toList(),
                        values: assistants.map((e) => e.id).toList(),
                        initialValue: args.meeting?.assistant?.id ??
                            (assistants.isNotEmpty ? assistants.first.id : null),
                      ),
                      const SizedBox(height: 12),
                      CustomDropdownField(
                        name: 'coAssistantId',
                        label: 'Pendamping',
                        items: assistants.map((e) => '${e.nickname} (${e.classOf})').toList(),
                        values: assistants.map((e) => e.id).toList(),
                        initialValue: args.meeting?.coAssistant?.id ??
                            (assistants.isNotEmpty ? assistants.first.id : null),
                      ),
                      const SizedBox(height: 12),
                      FileUploadField(
                        name: 'modulePath',
                        label: 'Modul',
                        extensions: const ['pdf', 'doc', 'docx'],
                        initialValue: args.meeting?.modulePath,
                      ),
                      const SizedBox(height: 12),
                      FileUploadField(
                        name: 'assignmentPath',
                        label: 'Soal praktikum',
                        extensions: const ['pdf', 'doc', 'docx'],
                        initialValue: args.meeting?.assignmentPath,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void createOrEditMeeting(BuildContext context, WidgetRef ref) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      final value = formKey.currentState!.value;

      if (value['assistantId'] == value['coAssistantId']) {
        context.showSnackBar(
          title: 'Terjadi Kesalahan',
          message: 'Pemateri & Pendamping tidak boleh asisten yang sama',
          type: SnackBarType.error,
        );

        return;
      }

      final meeting = MeetingPost(
        number: int.parse(value['number']),
        lesson: value['lesson'],
        date: (value['date'] as String).toSecondsSinceEpoch(),
        assistantId: value['assistantId'],
        coAssistantId: value['coAssistantId'],
        modulePath: value['modulePath'],
        assignmentPath: value['assignmentPath'],
      );

      if (args.meeting != null) {
        ref.read(meetingActionsProvider.notifier).editMeeting(args.meeting!, meeting);
      } else {
        ref.read(meetingActionsProvider.notifier).createMeeting(args.practicumId, meeting: meeting);
      }
    }
  }
}

class MeetingFormPageArgs {
  final String practicumId;
  final int? meetingNumber;
  final Meeting? meeting;

  const MeetingFormPageArgs({
    required this.practicumId,
    this.meetingNumber,
    this.meeting,
  });
}
