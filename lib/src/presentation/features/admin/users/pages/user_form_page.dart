// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_dropdown_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';

class UserFormPage extends StatelessWidget {
  final UserFormPageArgs args;

  const UserFormPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final listOfYears = List<int>.generate(
      7,
      (index) => DateTime.now().year - index,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: '${args.action} Pengguna',
        action: IconButton(
          onPressed: createOrEditUser,
          icon: const Icon(Icons.check_rounded),
          tooltip: 'Simpan',
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            FormBuilder(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    name: 'username',
                    label: 'Username',
                    hintText: 'Masukkan username',
                    textCapitalization: TextCapitalization.none,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: 'Field wajib diisi',
                      ),
                      FormBuilderValidators.match(
                        r'^(?=.*[a-zA-Z])\d*[a-zA-Z\d]*$',
                        errorText: 'Username tidak valid',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    name: 'fullname',
                    label: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkap',
                    textCapitalization: TextCapitalization.words,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: 'Field wajib diisi',
                      ),
                      FormBuilderValidators.match(
                        r'^(?=.*[a-zA-Z])[a-zA-Z\s.]*$',
                        errorText: 'Nama tidak valid',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomDropdownField(
                    name: 'classOf',
                    label: 'Angkatan',
                    items: listOfYears,
                    values: listOfYears,
                    initialValue: listOfYears.first,
                  ),
                  const SizedBox(height: 12),
                  CustomDropdownField(
                    name: 'role',
                    label: 'Role',
                    items: userRole.keys.toList().sublist(1),
                    values: userRole.values.toList().sublist(1),
                    initialValue: userRole.values.toList()[1],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF107C41),
                  ),
                  child: const Text('Import dari Excel'),
                ).fullWidth(),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF107C41),
                    side: const BorderSide(color: Color(0xFF107C41)),
                  ),
                  child: const Text('Download Template Excel'),
                ).fullWidth(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void createOrEditUser() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      debugPrint(formKey.currentState!.value.toString());

      navigatorKey.currentState!.pop();
    }
  }
}

class UserFormPageArgs {
  final String action;

  const UserFormPageArgs({required this.action});
}
