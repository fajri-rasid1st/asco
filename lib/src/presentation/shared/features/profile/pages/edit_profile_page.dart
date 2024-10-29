// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:asco/core/extensions/button_extension.dart';
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/services/image_service.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/utils/credential_saver.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/data/models/profiles/profile_post.dart';
import 'package:asco/src/presentation/features/common/initial/providers/credential_provider.dart';
import 'package:asco/src/presentation/providers/manual_providers/field_value_provider.dart';
import 'package:asco/src/presentation/shared/features/profile/providers/update_profile_provider.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_app_bar.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/password_field.dart';
import 'package:asco/src/presentation/shared/widgets/section_header.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = CredentialSaver.credential!;
    final updatePasswordFormKey = GlobalKey<FormBuilderState>();

    ref.listen(updateProfileProvider, (_, state) {
      state.whenOrNull(
        loading: () => context.showLoadingDialog(),
        error: (error, stackTrace) {
          navigatorKey.currentState!.pop();
          context.responseError(error, stackTrace);
        },
        data: (data) {
          navigatorKey.currentState!.pop();
          navigatorKey.currentState!.pop();
          ref.invalidate(credentialProvider);

          context.showSnackBar(
            title: 'Berhasil',
            message: 'Profile berhasil diperbarui',
          );
        },
      );
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        showCancelMessage(context);
      },
      child: Scaffold(
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
            onPressed: () => updateProfile(ref, profile),
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
                  CircleNetworkImage(
                    imageUrl: profile.profilePicturePath,
                    size: 128,
                    withBorder: true,
                    borderWidth: 2,
                    borderColor: Palette.background,
                    showPreviewWhenPressed: true,
                  ),
                  CircleBorderContainer(
                    size: 36,
                    withBorder: false,
                    fillColor: Palette.background,
                    onTap: () => showActionsModalBottomSheet(context, ref, profile),
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
                      initialValue: profile.fullname,
                      hintText: 'Masukkan nama lengkap',
                      textCapitalization: TextCapitalization.words,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: 'Field wajib diisi',
                        ),
                        FormBuilderValidators.match(
                          RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z\s.]*$'),
                          errorText: 'Nama tidak valid',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      name: 'nickname',
                      label: 'Nama Panggilan',
                      initialValue: profile.nickname,
                      hintText: 'Masukkan nama panggilan',
                      validators: [
                        FormBuilderValidators.match(
                          RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z.]*$'),
                          errorText: 'Nama tidak valid',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      name: 'githubUsername',
                      label: 'Username Github',
                      initialValue: profile.githubUsername,
                      hintText: 'Masukkan username Github',
                      textCapitalization: TextCapitalization.none,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      name: 'instagramUsername',
                      label: 'Username Instagram',
                      initialValue: profile.instagramUsername,
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
                      onChanged: (value) => ref.read(fieldValueProvider.notifier).state = value!,
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
                          textInputAction: TextInputAction.done,
                          validators: [
                            FormBuilderValidators.required(
                              errorText: 'Field wajib diisi',
                            ),
                            FormBuilderValidators.equal(
                              ref.watch(fieldValueProvider),
                              errorText: 'Konfirmasi password salah',
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => updatePassword(ref, profile, updatePasswordFormKey),
                      style: FilledButton.styleFrom(
                        backgroundColor: Palette.secondary,
                      ),
                      child: const Text('Ubah Password'),
                    ).fullWidth(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateProfile(
    WidgetRef ref,
    Profile profile,
  ) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!formKey.currentState!.saveAndValidate()) return;

    final value = formKey.currentState!.value;

    final updatedProfile = ProfilePost(
      username: profile.username!,
      classOf: profile.classOf!,
      role: profile.role!,
      fullname: value['fullname'],
      githubUsername: (value['githubUsername'] as String).isEmpty ? null : value['githubUsername'],
      instagramUsername: (value['instagramUsername'] as String).isEmpty ? null : value['instagramUsername'],
    );

    ref.read(updateProfileProvider.notifier).updateProfile(updatedProfile);
  }

  void updatePassword(
    WidgetRef ref,
    Profile profile,
    GlobalKey<FormBuilderState> formKey,
  ) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!formKey.currentState!.saveAndValidate()) return;

    final updatedProfile = ProfilePost(
      username: profile.username!,
      fullname: profile.fullname!,
      classOf: profile.classOf!,
      role: profile.role!,
      password: formKey.currentState!.value['confirmPassword'],
    );

    ref.read(updateProfileProvider.notifier).updateProfile(updatedProfile);
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

  Future<void> showActionsModalBottomSheet(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) async {
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => BottomSheet(
        onClosing: () {},
        enableDrag: false,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ActionListTile(
                icon: Icons.photo_camera_outlined,
                text: 'Ambil Gambar',
                onTap: () => getAndSetProfilePicture(ref, profile, ImageSource.camera),
              ),
              ActionListTile(
                icon: Icons.photo_library_outlined,
                text: 'Pilih File Gambar',
                onTap: () => getAndSetProfilePicture(ref, profile, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getAndSetProfilePicture(
    WidgetRef ref,
    Profile profile,
    ImageSource source,
  ) async {
    final imagePath = await ImageService.pickImage(source);

    if (imagePath != null) {
      final croppedImagePath = await ImageService.cropImage(
        imagePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (croppedImagePath != null) {
        navigatorKey.currentState!.pop();

        final updatedProfile = ProfilePost(
          username: profile.username!,
          fullname: profile.fullname!,
          classOf: profile.classOf!,
          role: profile.role!,
          profilePicturePath: croppedImagePath,
        );

        ref.read(updateProfileProvider.notifier).updateProfile(updatedProfile);
      }
    }
  }
}

class ActionListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ActionListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(
        icon,
        color: Palette.purple2,
      ),
      title: Text(text),
      textColor: Palette.purple2,
      onTap: onTap,
      visualDensity: const VisualDensity(vertical: -2),
    );
  }
}
