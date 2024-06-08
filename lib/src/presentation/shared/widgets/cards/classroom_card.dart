// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/classroom_form_dialog.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class ClassroomCard extends StatelessWidget {
  final bool showActionButtons;
  final VoidCallback? onTap;

  const ClassroomCard({
    super.key,
    this.showActionButtons = false,
    this.onTap,
  });

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
                  'Kelas A',
                  style: textTheme.titleMedium!.copyWith(
                    color: Palette.purple2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Setiap Sabtu 07.30 - 09.30',
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (showActionButtons) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const ClassroomFormDialog(action: 'Edit'),
              ),
              icon: SvgAsset(
                AssetPath.getIcon('pencil_outlined.svg'),
                width: 16,
              ),
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(32, 32),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: () => context.showConfirmDialog(
                title: 'Hapus Kelas?',
                message: 'Anda yakin ingin menghapus kelas ini?',
                primaryButtonText: 'Hapus',
                onPressedPrimaryButton: () {},
              ),
              icon: SvgAsset(
                AssetPath.getIcon('trash_outlined.svg'),
                width: 16,
              ),
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(32, 32),
                backgroundColor: Palette.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
