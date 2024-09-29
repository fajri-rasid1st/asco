// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/classroom_subtitle_type.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/svg_asset.dart';

class ClassroomCard extends StatelessWidget {
  final Classroom classroom;
  final ClassroomSubtitleType subtitleType;
  final bool showActionButtons;
  final VoidCallback? onUpdate;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ClassroomCard({
    super.key,
    required this.classroom,
    this.subtitleType = ClassroomSubtitleType.schedule,
    this.showActionButtons = false,
    this.onUpdate,
    this.onDelete,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelas ${classroom.name}',
                  style: textTheme.titleMedium!.copyWith(
                    color: Palette.purple2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitleType == ClassroomSubtitleType.schedule
                      ? 'Setiap ${MapHelper.readableDayMap[classroom.meetingDay]}, Pukul ${classroom.startTime?.to24TimeFormat()} - ${classroom.endTime?.to24TimeFormat()}'
                      : '${classroom.studentsLength} Peserta',
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (showActionButtons) ...[
            if (onUpdate != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: onUpdate,
                icon: SvgAsset(
                  AssetPath.getIcon('pencil_outlined.svg'),
                  width: 16,
                ),
                style: IconButton.styleFrom(
                  minimumSize: const Size(32, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
            const SizedBox(width: 6),
            IconButton(
              onPressed: onDelete,
              icon: SvgAsset(
                AssetPath.getIcon('trash_outlined.svg'),
                color: onDelete != null ? Palette.background : Palette.border,
                width: 16,
              ),
              style: IconButton.styleFrom(
                backgroundColor: onDelete != null ? Palette.error : Palette.secondaryBackground,
                minimumSize: const Size(32, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
