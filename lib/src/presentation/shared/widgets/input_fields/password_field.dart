// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';

class PasswordField extends StatefulWidget {
  final String name;
  final String label;
  final String? hintText;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<String? Function(String?)>? validators;
  final ValueChanged<String?>? onChanged;

  const PasswordField({
    super.key,
    required this.name,
    required this.label,
    this.hintText,
    this.textInputType = TextInputType.visiblePassword,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.validators,
    this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late final ValueNotifier<bool> isVisible;

  @override
  void initState() {
    super.initState();

    isVisible = ValueNotifier(false);
  }

  @override
  void dispose() {
    super.dispose();

    isVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        ValueListenableBuilder(
          valueListenable: isVisible,
          builder: (context, isVisible, child) {
            return FormBuilderTextField(
              name: widget.name,
              obscureText: !isVisible,
              keyboardType: widget.textInputType,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              textAlignVertical: TextAlignVertical.center,
              style: textTheme.bodyLarge,
              decoration: InputDecoration(
                filled: true,
                fillColor: Palette.background,
                suffixIcon: buildSuffixIcon(isVisible),
                hintText: widget.hintText,
                contentPadding: const EdgeInsets.all(16),
              ),
              validator: widget.validators != null
                  ? FormBuilderValidators.compose(widget.validators!)
                  : null,
              onChanged: widget.onChanged,
            );
          },
        ),
      ],
    );
  }

  IconButton buildSuffixIcon(bool isVisible) {
    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: Palette.primaryText,
        size: 20,
      ),
      onPressed: () => this.isVisible.value = !isVisible,
    );
  }
}
