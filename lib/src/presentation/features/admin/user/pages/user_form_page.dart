// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/enums/snack_bar_type.dart';
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/excel_helper.dart';
import 'package:asco/core/services/file_service.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/data/models/profiles/profile_post.dart';
import 'package:asco/src/presentation/features/admin/user/providers/user_actions_provider.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_dropdown_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/file_upload_field.dart';

class UserFormPage extends StatelessWidget {
  final Profile? user;

  const UserFormPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final listOfYears = List<String>.generate(
      10,
      (index) => '${DateTime.now().year - index}',
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: '${user != null ? 'Edit' : 'Tambah'} Pengguna',
        action: Consumer(
          builder: (context, ref, child) {
            return IconButton(
              onPressed: () => createOrEditUser(ref),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(
                name: 'username',
                label: 'Username',
                hintText: 'Masukkan username',
                initialValue: user?.username,
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
                initialValue: user?.fullname,
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
                initialValue: user?.classOf ?? listOfYears.first,
              ),
              const SizedBox(height: 12),
              CustomDropdownField(
                name: 'role',
                label: 'Role',
                items: userRoleFilter.keys.toList().sublist(1),
                values: userRoleFilter.values.toList().sublist(1),
                initialValue: user?.role ?? userRoleFilter.values.toList()[1],
              ),
              if (user == null) ...[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 12,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Palette.divider,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        color: Palette.scaffoldBackground,
                        child: Text(
                          'atau import file Excel',
                          style: textTheme.bodyMedium!.copyWith(
                            color: Palette.purple2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const FileUploadField(
                  name: 'excelPath',
                  label: 'File Excel',
                  extensions: ['xlsx'],
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () => downloadExcelTemplate(context),
                  child: const Text('Download Template Excel'),
                ).fullWidth(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void createOrEditUser(WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();

    String? excelPath = formKey.currentState!.instantValue['excelPath'];

    if (excelPath != null) {
      final excelData = ExcelHelper.convertToData(excelPath);

      if (excelData != null) {
        final users = List<ProfilePost>.generate(
          excelData.length,
          (index) => ProfilePost.fromJson(excelData[index]),
        );

        ref.read(userActionsProvider.notifier).createUser(users);
      }
    } else {
      if (formKey.currentState!.saveAndValidate()) {
        final value = formKey.currentState!.value;

        final user = ProfilePost(
          username: value['username'],
          fullname: value['fullname'],
          classOf: value['classOf'],
          role: value['role'],
          password: value['username'],
        );

        if (this.user != null) {
          ref
              .read(userActionsProvider.notifier)
              .editUser(this.user!.username!, user.copyWith(password: null));
        } else {
          ref.read(userActionsProvider.notifier).createUser([user]);
        }
      }
    }
  }

  void downloadExcelTemplate(BuildContext context) async {
    if (await FileService.saveFileFromAsset('create_users_template.xlsx')) {
      if (!context.mounted) return;

      context.showSnackBar(
        title: 'Berhasil',
        message: 'Template file excel berhasil di-download.',
      );
    } else {
      if (!context.mounted) return;

      context.showSnackBar(
        title: 'Terjadi Kesalahan',
        message: 'Terjadi kesalahan saat mendownload file.',
        type: SnackBarType.error,
      );
    }
  }
}
