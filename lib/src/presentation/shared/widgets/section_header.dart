import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showDivider;
  final bool showActionButton;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressedActionButton;

  const SectionHeader({
    super.key,
    required this.title,
    this.showDivider = false,
    this.showActionButton = false,
    this.padding = const EdgeInsets.fromLTRB(4, 12, 4, 6),
    this.onPressedActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Text(
            title,
            style: textTheme.titleLarge!.copyWith(
              color: Palette.purple2,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showDivider)
            Expanded(
              child: Container(
                height: 1,
                color: Palette.divider,
                margin: EdgeInsets.only(
                  left: 8,
                  right: showActionButton ? 12 : 0,
                ),
              ),
            ),
          if (showActionButton)
            CircleBorderContainer(
              size: 28,
              borderColor: Palette.purple3,
              fillColor: Palette.purple3,
              onTap: onPressedActionButton,
              child: const Icon(
                Icons.add_rounded,
                color: Palette.background,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}
