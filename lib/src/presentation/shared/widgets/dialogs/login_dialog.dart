// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/custom_icon_button.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Palette.scaffoldBackground.withOpacity(.9),
      surfaceTintColor: Palette.scaffoldBackground.withOpacity(.9),
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Masuk',
                  style: textTheme.headlineLarge!.copyWith(
                    color: Palette.purple3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Untuk mendapatkan informasi akun Anda, silahkan hubungi Koordinator Lab.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const LoginForm(),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 12,
            child: CustomIconButton(
              'close_outlined.svg',
              onPressed: () => navigatorKey.currentState!.pop(),
              color: Palette.secondaryText,
              size: 20,
              tooltip: 'Kembali',
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final GlobalKey<FormBuilderState> formKey;
  late final ValueNotifier<bool> isVisible;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormBuilderState>();
    isVisible = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    isVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Username',
            style: textTheme.bodyMedium!.copyWith(
              color: Palette.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          FormBuilderTextField(
            name: 'username',
            textInputAction: TextInputAction.next,
            textAlignVertical: TextAlignVertical.center,
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              filled: true,
              fillColor: Palette.background,
              hintText: 'Masukkan username',
              hintStyle: textTheme.bodyMedium!.copyWith(
                color: Palette.hint,
              ),
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Palette.purple3,
                  child: SvgAsset(
                    AssetPath.getIcon('person_filled.svg'),
                    color: Palette.background,
                    width: 16,
                  ),
                ),
              ),
            ),
            validator: FormBuilderValidators.required(
              errorText: 'Field wajib diisi',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Password',
            style: textTheme.bodyMedium!.copyWith(
              color: Palette.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          ValueListenableBuilder(
            valueListenable: isVisible,
            builder: (context, isVisible, child) {
              return FormBuilderTextField(
                name: 'password',
                obscureText: !isVisible,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                textAlignVertical: TextAlignVertical.center,
                style: textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.background,
                  hintText: 'Masukkan password',
                  hintStyle: textTheme.bodyMedium!.copyWith(
                    color: Palette.hint,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Palette.purple3,
                      child: SvgAsset(
                        AssetPath.getIcon('lock_filled.svg'),
                        color: Palette.background,
                        width: 16,
                      ),
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Palette.primaryText,
                      size: 20,
                    ),
                    onPressed: () => this.isVisible.value = !isVisible,
                  ),
                ),
                validator: FormBuilderValidators.required(
                  errorText: 'Field wajib diisi',
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: SvgAsset(
              AssetPath.getIcon('arrow_forward_outlined.svg'),
              color: Palette.background,
              width: 20,
            ),
            label: Text(
              'Masuk',
              style: textTheme.labelLarge!.copyWith(
                color: Palette.background,
              ),
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            onPressed: login,
          ),
        ],
      ),
    );
  }

  void login() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.saveAndValidate()) {
      navigatorKey.currentState!.pop();

      navigatorKey.currentState!.pushReplacementNamed(adminHomeRoute);
    }
  }
}
