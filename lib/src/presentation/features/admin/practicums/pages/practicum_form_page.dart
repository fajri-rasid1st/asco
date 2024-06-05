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
    String? badgePath;
    String? courseContractPath;

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
          onPressed: () => createOrEditPracticum(badgePath, courseContractPath),
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
                label: 'Badge',
                extensions: const ['jpg', 'jpeg', 'png'],
                onChanged: (path) => badgePath = path,
              ),
              const SizedBox(height: 12),
              FileUploadField(
                label: 'Kontrak Kuliah',
                extensions: const ['pdf', 'doc', 'docx'],
                onChanged: (path) => courseContractPath = path,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createOrEditPracticum(String? badgePath, String? courseContractPath) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      debugPrint({
        'course': formKey.currentState!.value['course'],
        'badgePath': badgePath,
        'courseContractPath': courseContractPath,
      }.toString());
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
