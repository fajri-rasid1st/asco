// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      showCheckmark: false,
      selected: selected,
      onSelected: onSelected,
      selectedColor: Palette.purple2,
      backgroundColor: Palette.scaffoldBackground,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 20),
      labelStyle: textTheme.bodyMedium!.copyWith(
        color: selected ? Palette.background : Palette.purple2,
        letterSpacing: 0,
      ),
      side: const BorderSide(color: Palette.purple2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
}