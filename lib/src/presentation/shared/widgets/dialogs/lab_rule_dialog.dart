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

class LabRuleDialog extends StatelessWidget {
  final String fieldName;

  const LabRuleDialog({super.key, required this.fieldName});

  @override
  Widget build(BuildContext context) {
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
                          'Sanksi Nilai Asistensi',
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium!.copyWith(
                            color: Palette.purple2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Terlambat asistensi <1 minggu',
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
                  child: IconButton(
                    onPressed: () => submit(formKey),
                    icon: SvgAsset(
                      AssetPath.getIcon('check_outlined.svg'),
                      color: Palette.primary,
                      width: 26,
                    ),
                    tooltip: 'Submit',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: FormBuilder(
                key: formKey,
                child: CustomTextField(
                  name: fieldName,
                  label: 'Pengurangan Poin',
                  isSmall: true,
                  hintText: 'Masukkan jumlah poin',
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Field wajib diisi',
                    ),
                    FormBuilderValidators.integer(
                      errorText: 'Field harus berupa angka integer',
                    ),
                    FormBuilderValidators.min(
                      0,
                      errorText: 'Poin minimal adalah 0',
                    ),
                    FormBuilderValidators.max(
                      50,
                      errorText: 'Poin maksimal adalah 50',
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
