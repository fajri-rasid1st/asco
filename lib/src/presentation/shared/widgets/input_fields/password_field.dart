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
  final TextInputAction textInputAction;
  final List<String? Function(String?)>? validators;
  final ValueChanged<String?>? onChanged;

  const PasswordField({
    super.key,
    required this.name,
    required this.label,
    this.hintText,
    this.textInputAction = TextInputAction.next,
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
    isVisible = ValueNotifier(false);

    super.initState();
  }

  @override
  void dispose() {
    isVisible.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textTheme.titleSmall!.copyWith(
            color: Palette.purple2,
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
              keyboardType: TextInputType.visiblePassword,
              textInputAction: widget.textInputAction,
              textAlignVertical: TextAlignVertical.center,
              style: textTheme.bodyLarge,
              decoration: InputDecoration(
                filled: true,
                fillColor: Palette.background,
                contentPadding: const EdgeInsets.all(16),
                hintText: widget.hintText,
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Palette.primaryText,
                    size: 20,
                  ),
                  onPressed: () => this.isVisible.value = !isVisible,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
              validator: widget.validators != null ? FormBuilderValidators.compose(widget.validators!) : null,
              onChanged: widget.onChanged,
            );
          },
        ),
      ],
    );
  }
}
