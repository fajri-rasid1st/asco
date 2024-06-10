// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';

class AssistanceGroupCard extends StatelessWidget {
  final VoidCallback? onTap;

  const AssistanceGroupCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      color: Palette.background,
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grup Asistensi 1',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge!.copyWith(
                    color: Palette.purple2,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Muh. Adrian Dwi Putra',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium!.copyWith(
                    color: Palette.purple3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '10 Peserta',
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          CircleBorderContainer(
            size: 28,
            borderColor: Palette.pink2,
            fillColor: Palette.error,
            onTap: () => context.showConfirmDialog(
              title: 'Hapus Grup Asistensi?',
              message: 'Anda yakin ingin menghapus grup asistensi ini?',
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
      ),
    );
  }
}
