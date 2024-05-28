// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/presentation/shared/widgets/input_fields/custom_text_field.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class GithubRepositoryDialog extends StatelessWidget {
  const GithubRepositoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 36,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: IconButton(
                    onPressed: () => navigatorKey.currentState!.pop(),
                    icon: SvgAsset(
                      assetName: AssetPath.getIcon('close_outlined.svg'),
                      color: primaryTextColor,
                    ),
                    tooltip: 'Close',
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Link Repository',
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium!.copyWith(
                            color: purple2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pemrograman Mobile A (Grup 3)',
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall!.copyWith(
                            color: purple3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 4),
                  child: IconButton(
                    onPressed: () => submit(formKey),
                    icon: SvgAsset(
                      assetName: AssetPath.getIcon('check_outlined.svg'),
                      color: primaryColor,
                      width: 26,
                    ),
                    tooltip: 'Submit',
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
                  hintText: 'Link repository Github',
                  isSmall: true,
                  prefixIconName: 'github_filled.svg',
                  textInputType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Field wajib diisi',
                    ),
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

    if (formKey.currentState!.saveAndValidate()) {
      debugPrint(formKey.currentState!.value.toString());
    }
  }
}
