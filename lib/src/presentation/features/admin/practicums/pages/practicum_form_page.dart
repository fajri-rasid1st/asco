// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/pages/select_users_page.dart';
import 'package:asco/src/presentation/shared/widgets/cards/classroom_card.dart';
import 'package:asco/src/presentation/shared/widgets/cards/user_card.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/classroom_form_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';

class PracticumFirstFormPage extends StatelessWidget {
  final PracticumFormPageArgs args;

  const PracticumFirstFormPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${args.action} Praktikum (1/2)',
        action: IconButton(
          onPressed: createOrEditPracticum,
          icon: const Icon(Icons.chevron_right_rounded),
          iconSize: 30,
          tooltip: 'Selanjutnya',
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
                name: 'course',
                label: 'Mata kuliah',
                hintText: 'Masukkan nama mata kuliah',
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Field wajib diisi',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FileUploadField(
                name: 'badgePath',
                label: 'Badge',
                extensions: const [],
                validator: FormBuilderValidators.required(),
                onPressedFilePickerButton: () async {
                  final result =
                      await navigatorKey.currentState!.pushNamed(practicumBadgeGeneratorRoute);

                  if (result != null && context.mounted) {
                    context.showSnackBar(
                      title: 'Badge Berhasil Dibuat',
                      message: 'File badge berhasil dibuat dan dimasukkan.',
                    );
                  }

                  return result as String?;
                },
              ),
              const SizedBox(height: 12),
              FileUploadField(
                name: 'courseContractPath',
                label: 'Kontrak Kuliah',
                extensions: const ['pdf', 'doc', 'docx'],
                validator: FormBuilderValidators.required(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createOrEditPracticum() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      debugPrint(formKey.currentState!.value.toString());

      navigatorKey.currentState!.pushNamed(
        practicumSecondFormRoute,
        arguments: args,
      );
    }
  }
}

class PracticumSecondFormPage extends StatelessWidget {
  final PracticumFormPageArgs args;

  const PracticumSecondFormPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    List<int> selectedAssistants = [];

    return Scaffold(
      appBar: CustomAppBar(
        title: '${args.action} Praktikum (2/2)',
        action: IconButton(
          onPressed: () => updatePracticum(selectedAssistants),
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
        child: Column(
          children: [
            SectionHeader(
              title: 'Kelas',
              padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
              showDivider: true,
              showActionButton: true,
              onPressedActionButton: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const ClassroomFormDialog(action: 'Tambah'),
              ),
            ),
            ...List<Padding>.generate(
              4,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == 3 ? 0 : 10,
                ),
                child: const ClassroomCard(showActionButtons: true),
              ),
            ),
            SectionHeader(
              title: 'Asisten',
              padding: const EdgeInsets.fromLTRB(4, 16, 0, 8),
              showDivider: true,
              showActionButton: true,
              onPressedActionButton: () async {
                final result = await navigatorKey.currentState!.pushNamed(
                  selectUsersRoute,
                  arguments: const SelectUsersPageArgs(
                    title: 'Asisten - Pemrograman Mobile',
                    role: 'Asisten',
                  ),
                );

                if (result != null) selectedAssistants = result as List<int>;
              },
            ),
            ...List<Padding>.generate(
              4,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == 3 ? 0 : 10,
                ),
                child: UserCard(
                  showBadge: false,
                  showDeleteButton: true,
                  onPressedDeleteButton: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updatePracticum(List<int> selectedAssistants) {
    debugPrint(selectedAssistants.toString());
  }
}

class PracticumFormPageArgs {
  final String action;

  const PracticumFormPageArgs({required this.action});
}
