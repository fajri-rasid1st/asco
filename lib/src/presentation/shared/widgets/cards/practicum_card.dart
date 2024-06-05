// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';

class PracticumCard extends StatelessWidget {
  final bool showDeleteButton;
  final VoidCallback? onTap;

  const PracticumCard({
    super.key,
    this.showDeleteButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: Palette.background,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      onTap: onTap,
      child: Row(
        children: [
          const PracticumBadgeImage(
            badgeUrl: 'https://placehold.co/138x150/png',
            width: 48,
            height: 52,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pemrograman Mobile',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Palette.purple2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '4 Kelas',
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.purple3,
                  ),
                ),
              ],
            ),
          ),
          if (showDeleteButton) ...[
            const SizedBox(width: 8),
            CircleBorderContainer(
              size: 28,
              borderColor: Palette.pink2,
              fillColor: Palette.error,
              onTap: () => context.showConfirmDialog(
                title: 'Hapus Praktikum?',
                message: 'Anda yakin ingin menghapus praktikum ini?',
                primaryButtonText: 'Hapus',
                onPressedPrimaryButton: () {},
              ),
              child: const Icon(
                Icons.remove_rounded,
                size: 18,
                color: Palette.background,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
