// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';

final badgePathProvider = StateProvider.autoDispose<String?>((ref) => null);
final courseContractPathProvider = StateProvider.autoDispose<String?>((ref) => null);

class PracticumFirstFormPage extends ConsumerWidget {
  final PracticumFormPageArgs args;

  const PracticumFirstFormPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();

    final badgePath = ref.watch(badgePathProvider);
    final courseContractPath = ref.watch(courseContractPathProvider);

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
          onPressed: () => createOrEditPracticum(formKey),
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
                onFileChanged: (path) {
                  print('kontol: $path');
                  // ref.read(badgePathProvider.notifier).state = path;
                  // print('kontol: $badgePath');
                },
              ),
              const SizedBox(height: 12),
              FileUploadField(
                label: 'Kontrak Kuliah',
                extensions: const ['pdf', 'doc', 'docx'],
                onFileChanged: (path) => ref.read(courseContractPathProvider.notifier).state = path,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createOrEditPracticum(
    GlobalKey<FormBuilderState> formKey,
  ) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      // debugPrint({
      //   'course': formKey.currentState!.value['course'],
      //   'badgePath': ref.watch(badgePathProvider),
      //   'courseContractPath': ref.watch(courseContractPathProvider),
      // }.toString());
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
