// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';

class MeetingCard extends StatelessWidget {
  final bool showDeleteButton;
  final VoidCallback? onTap;

  const MeetingCard({
    super.key,
    this.showDeleteButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 99,
      color: Palette.background,
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      onTap: onTap,
      child: Row(
        children: [
          CircleBorderContainer(
            size: 56,
            withBorder: false,
            fillColor: Palette.purple3,
            child: Text(
              '#1',
              style: textTheme.titleMedium!.copyWith(
                color: Palette.background,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipe Data dan Attribute',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    color: Palette.purple2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '26 Februari 2024',
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.secondaryText,
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
                title: 'Hapus Pertemuan?',
                message: 'Anda yakin ingin menghapus pertemuan ini?',
                primaryButtonText: 'Hapus',
                onPressedPrimaryButton: () {},
              ),
              child: const Icon(
                Icons.remove_rounded,
                color: Palette.background,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
