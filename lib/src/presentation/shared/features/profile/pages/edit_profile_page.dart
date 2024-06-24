// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/password_field.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

final newPasswordProvider = StateProvider.autoDispose<String>((ref) => '');

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatePasswordFormKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profil',
        leading: IconButton(
          onPressed: () => showCancelMessage(context),
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Batalkan',
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
          ),
        ),
        action: IconButton(
          onPressed: updateProfile,
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
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleNetworkImage(
                  imageUrl: 'https://placehold.co/300x300/png',
                  size: 128,
                  withBorder: true,
                  borderWidth: 2,
                  borderColor: Palette.background,
                ),
                CircleBorderContainer(
                  size: 36,
                  withBorder: false,
                  fillColor: Palette.background,
                  onTap: () {},
                  child: SvgAsset(
                    AssetPath.getIcon('camera_filled.svg'),
                    width: 20,
                  ),
                ),
              ],
            ),
            FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  const SectionHeader(
                    title: 'Data Diri',
                    showDivider: true,
                    padding: EdgeInsets.only(
                      top: 24,
                      bottom: 8,
                    ),
                  ),
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
                  CustomTextField(
                    name: 'nickname',
                    label: 'Nama Panggilan',
                    hintText: 'Masukkan nama panggilan',
                    validators: [
                      FormBuilderValidators.match(
                        r'^(?=.*[a-zA-Z])[a-zA-Z.]*$',
                        errorText: 'Nama tidak valid',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const CustomTextField(
                    name: 'githubUsername',
                    label: 'Username Github',
                    hintText: 'Masukkan username Github',
                    textCapitalization: TextCapitalization.none,
                  ),
                  const SizedBox(height: 12),
                  const CustomTextField(
                    name: 'instagramUsername',
                    label: 'Username Instagram',
                    hintText: 'Masukkan username Instagram',
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.none,
                  ),
                ],
              ),
            ),
            FormBuilder(
              key: updatePasswordFormKey,
              child: Column(
                children: [
                  const SectionHeader(
                    title: 'Ubah Password',
                    showDivider: true,
                    padding: EdgeInsets.only(
                      top: 20,
                      bottom: 8,
                    ),
                  ),
                  PasswordField(
                    name: 'oldPassword',
                    label: 'Password Lama',
                    hintText: 'Masukkan password lama',
                    validators: [
                      FormBuilderValidators.required(
                        errorText: 'Field wajib diisi',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PasswordField(
                    name: 'newPassword',
                    label: 'Password Baru',
                    hintText: 'Masukkan password baru',
                    onChanged: (value) => ref.read(newPasswordProvider.notifier).state = value!,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: 'Field wajib diisi',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Consumer(
                    builder: (context, ref, child) {
                      return PasswordField(
                        name: 'confirmPassword',
                        label: 'Konfirmasi Password Baru',
                        hintText: 'Masukkan kembali password baru',
                        validators: [
                          FormBuilderValidators.required(
                            errorText: 'Field wajib diisi',
                          ),
                          FormBuilderValidators.equal(
                            ref.watch(newPasswordProvider),
                            errorText: 'Konfirmasi password salah',
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => updatePassword(updatePasswordFormKey),
                    style: FilledButton.styleFrom(
                      backgroundColor: Palette.purple2,
                    ),
                    child: const Text('Ubah Password'),
                  ).fullWidth()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateProfile() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      debugPrint(formKey.currentState!.value.toString());
    }
  }

  void updatePassword(GlobalKey<FormBuilderState> formKey) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      debugPrint(formKey.currentState!.value.toString());
    }
  }

  void showCancelMessage(BuildContext context) {
    context.showConfirmDialog(
      title: 'Batalkan Edit Profil?',
      message: 'Perubahan yang Anda lakukan tidak akan disimpan.',
      primaryButtonText: 'Batalkan',
      onPressedPrimaryButton: () {
        navigatorKey.currentState!.pop();
        navigatorKey.currentState!.pop();
      },
    );
  }
}
