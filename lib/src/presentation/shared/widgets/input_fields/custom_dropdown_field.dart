// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';

class CustomDropdownField extends StatefulWidget {
  final String name;
  final String label;
  final List items;
  final List values;
  final dynamic initialValue;
  final bool isSmall;

  const CustomDropdownField({
    super.key,
    required this.name,
    required this.label,
    required this.items,
    required this.values,
    this.initialValue,
    this.isSmall = false,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
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
        Focus(
          onFocusChange: (value) => isFocus.value = value,
          child: FormBuilderDropdown(
            name: widget.name,
            initialValue: widget.initialValue,
            elevation: 1,
            style: widget.isSmall ? textTheme.bodyMedium : textTheme.bodyLarge,
            items: List<DropdownMenuItem>.generate(
              widget.items.length,
              (index) => DropdownMenuItem(
                value: widget.values[index],
                child: Text('${widget.items[index]}'),
              ),
            ),
            icon: ValueListenableBuilder(
              valueListenable: isFocus,
              builder: (context, isFocus, child) {
                return Icon(
                  Icons.expand_more_rounded,
                  color: isFocus ? Palette.purple2 : Palette.disabledText,
                );
              },
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Palette.background,
              contentPadding: widget.isSmall
                  ? const EdgeInsets.fromLTRB(16, 12, 12, 12)
                  : const EdgeInsets.fromLTRB(16, 16, 12, 16),
            ),
          ),
        ),
      ],
    );
  }
}
