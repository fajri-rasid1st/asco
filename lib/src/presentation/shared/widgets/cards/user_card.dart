// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';

class UserCard extends StatelessWidget {
  final Widget? trailing;
  final bool showAvatarBorder;
  final bool showDeleteButton;
  final bool showBadge;
  final String? badgeText;
  final VoidCallback? onPressedDeleteButton;
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    this.trailing,
    this.showAvatarBorder = false,
    this.showDeleteButton = false,
    this.showBadge = true,
    this.badgeText,
    this.onPressedDeleteButton,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: Palette.background,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 14,
      ),
      onTap: onTap,
      child: Row(
        children: [
          CircleNetworkImage(
            imageUrl: 'https://placehold.co/150x150/png',
            size: 60,
            withBorder: showAvatarBorder,
            borderColor: Palette.purple2,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'H071211074',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.purple3,
                  ),
                ),
                SizedBox(height: showBadge ? 1 : 2),
                Text(
                  'Muh. Sultan Nazhim Latenri Tatta S.H',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Palette.purple2,
                  ),
                ),
                if (showBadge) ...[
                  const SizedBox(height: 2),
                  CustomBadge(
                    text: badgeText ?? 'Praktikan',
                  ),
                ],
              ],
            ),
          ),
          if (trailing == null && showDeleteButton) ...[
            const SizedBox(width: 8),
            CircleBorderContainer(
              size: 28,
              borderColor: Palette.pink2,
              fillColor: Palette.error,
              onTap: onPressedDeleteButton,
              child: const Icon(
                Icons.remove_rounded,
                color: Palette.background,
                size: 18,
              ),
            ),
          ],
          if (trailing != null && !showDeleteButton) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
