// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/user_badge_type.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';

class UserCard extends StatelessWidget {
  final Widget? trailing;
  final bool showDeleteButton;
  final UserBadgeType badgeType;
  final String? badgeText;
  final VoidCallback? onPressedDeleteButton;
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    this.trailing,
    this.showDeleteButton = false,
    this.badgeType = UserBadgeType.pill,
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
          const CircleNetworkImage(
            imageUrl: 'https://placehold.co/150x150/png',
            size: 60,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
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
                const SizedBox(height: 1),
                Text(
                  'Muh. Sultan Nazhim Latenri Tatta S.H',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall!.copyWith(
                    color: Palette.purple2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                if (badgeType == UserBadgeType.pill)
                  CustomBadge(
                    text: badgeText ?? 'Praktikan',
                  )
                else
                  Text(
                    badgeText ?? '2021',
                    style: textTheme.labelSmall!.copyWith(
                      color: Palette.secondaryText,
                      height: 1,
                    ),
                  ),
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
