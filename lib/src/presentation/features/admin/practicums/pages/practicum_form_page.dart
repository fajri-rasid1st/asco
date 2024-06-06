// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';

class PracticumFirstFormPage extends StatelessWidget {
  final PracticumFormPageArgs args;

  const PracticumFirstFormPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${args.action} Praktikum (1/2)',
        leading: IconButton(
          onPressed: () => navigatorKey.currentState!.pop(),
          icon: const Icon(Icons.close_rounded),
          iconSize: 22,
          tooltip: 'Kembali',
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
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
                extensions: const ['jpg', 'jpeg', 'png'],
                validator: FormBuilderValidators.required(),
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
    }
  }
}

class PracticumSecondFormPage extends StatelessWidget {
  final PracticumFormPageArgs args;

  const PracticumSecondFormPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

class PracticumFormPageArgs {
  final String action;

  const PracticumFormPageArgs({required this.action});
}
