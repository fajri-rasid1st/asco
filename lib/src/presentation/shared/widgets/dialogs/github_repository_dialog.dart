// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/providers/manual_providers/field_value_provider.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class GithubRepositoryDialog extends ConsumerWidget {
  const GithubRepositoryDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: IconButton(
                    onPressed: () => navigatorKey.currentState!.pop(),
                    icon: SvgAsset(
                      AssetPath.getIcon('close_outlined.svg'),
                      color: Palette.primaryText,
                    ),
                    tooltip: 'Kembali',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Text(
                          'Link Repository',
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium!.copyWith(
                            color: Palette.purple2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pemrograman Mobile A (Grup 3)',
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall!.copyWith(
                            color: Palette.purple3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 4),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final value = ref.watch(fieldValueProvider);

                      return IconButton(
                        onPressed: value.isEmpty ? null : () => submit(formKey),
                        icon: SvgAsset(
                          AssetPath.getIcon('check_outlined.svg'),
                          color: value.isEmpty ? Palette.secondaryText : Palette.primary,
                          width: 26,
                        ),
                        tooltip: 'Submit',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          shape: const CircleBorder(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: FormBuilder(
                key: formKey,
                child: CustomTextField(
                  name: 'githubRepoLink',
                  label: 'Link Repository Github',
                  isSmall: true,
                  hintText: 'Link repository Github',
                  prefixIconName: 'github_filled.svg',
                  textInputType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.none,
                  onChanged: (value) => ref.read(fieldValueProvider.notifier).state = value ?? '',
                  validators: [
                    FormBuilderValidators.url(
                      errorText: 'Field harus berupa URL',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit(GlobalKey<FormBuilderState> formKey) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!formKey.currentState!.saveAndValidate()) return;
  }
}
