// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/circle_network_image.dart';
import 'package:asco/src/presentation/shared/widgets/custom_badge.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';

class UserCard extends StatelessWidget {
  final VoidCallback? onTap;

  const UserCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: Palette.background,
      padding: const EdgeInsets.all(12),
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
                Text(
                  'Muh. Sultan Nazhim Latenri Tatta S.H',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Palette.purple2,
                  ),
                ),
                const SizedBox(height: 2),
                const CustomBadge(text: 'Praktikan'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          CircleBorderContainer(
            size: 30,
            borderColor: Palette.pink2,
            fillColor: Palette.error,
            child: const Icon(
              Icons.remove_rounded,
              size: 18,
              color: Palette.background,
            ),
            onTap: () => context.showConfirmDialog(
              title: 'Hapus Pengguna?',
              message: 'Anda yakin ingin menghapus user ini?',
              primaryButtonText: 'Hapus',
              onPressedPrimaryButton: () {},
            ),
          ),
        ],
      ),
    );
  }
}
