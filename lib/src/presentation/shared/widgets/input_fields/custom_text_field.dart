// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class CustomTextField extends StatefulWidget {
  final bool enabled;
  final String name;
  final String label;
  final String? initialValue;
  final String? hintText;
  final int maxLines;
  final TextInputType? textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final String? prefixIconName;
  final String? suffixIconName;
  final List<String? Function(String?)>? validators;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixIconTap;
  final bool isSmall;

  const CustomTextField({
    super.key,
    this.enabled = true,
    required this.name,
    required this.label,
    this.initialValue,
    this.hintText,
    this.maxLines = 1,
    this.textInputType,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.sentences,
    this.prefixIconName,
    this.suffixIconName,
    this.validators,
    this.onTap,
    this.onSuffixIconTap,
    this.isSmall = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final ValueNotifier<bool> isFocus;

  @override
  void initState() {
    super.initState();

    isFocus = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    isFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: widget.isSmall
              ? textTheme.bodySmall!.copyWith(
                  color: Palette.purple2,
                  fontWeight: FontWeight.w600,
                )
              : textTheme.titleSmall!.copyWith(
                  color: Palette.purple2,
                  fontWeight: FontWeight.w600,
                ),
        ),
        const SizedBox(height: 6),
        if (widget.prefixIconName != null)
          Focus(
            onFocusChange: (value) => isFocus.value = value,
            child: buildCustomTextField(),
          )
        else
          buildCustomTextField(),
      ],
    );
  }

  FormBuilderTextField buildCustomTextField() {
    return FormBuilderTextField(
      enabled: widget.enabled,
      name: widget.name,
      initialValue: widget.initialValue,
      maxLines: widget.maxLines,
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      textAlignVertical: TextAlignVertical.center,
      style: widget.isSmall
          ? textTheme.bodyMedium!.copyWith(
              color: widget.enabled ? Palette.primaryText : Palette.disabledText,
            )
          : textTheme.bodyLarge!.copyWith(
              color: widget.enabled ? Palette.primaryText : Palette.disabledText,
            ),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.enabled ? Palette.background : Palette.disabled,
        contentPadding: widget.isSmall
            ? const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              )
            : const EdgeInsets.all(16),
        hintText: widget.hintText,
        hintStyle: widget.isSmall
            ? textTheme.bodyMedium!.copyWith(
                color: Palette.hint,
                height: 1,
              )
            : null,
        prefixIcon: widget.prefixIconName != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
                child: ValueListenableBuilder(
                  valueListenable: isFocus,
                  builder: (context, isFocus, child) => SvgAsset(
                    AssetPath.getIcon(widget.prefixIconName!),
                    color: isFocus ? Palette.purple2 : Palette.hint,
                    width: widget.isSmall ? 16 : null,
                  ),
                ),
              )
            : null,
        suffixIcon: widget.suffixIconName != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 16, 0),
                child: GestureDetector(
                  onTap: widget.onSuffixIconTap,
                  child: SvgAsset(
                    AssetPath.getIcon(widget.suffixIconName!),
                    color: Palette.primaryText,
                    width: widget.isSmall ? 16 : 20,
                  ),
                ),
              )
            : null,
      ),
      validator:
          widget.validators != null ? FormBuilderValidators.compose(widget.validators!) : null,
      onTap: widget.onTap,
    );
  }
}
