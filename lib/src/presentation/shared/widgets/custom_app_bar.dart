// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Widget? action;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      titleTextStyle: textTheme.titleLarge!.copyWith(
        color: Palette.background,
        fontWeight: FontWeight.w600,
        fontSize: 17,
      ),
      leading: leading ??
          IconButton(
            onPressed: () => navigatorKey.currentState!.pop(),
            icon: const Icon(Icons.chevron_left_rounded),
            iconSize: 30,
            tooltip: 'Kembali',
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: const CircleBorder(),
            ),
          ),
      actions: action != null ? [action!] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
