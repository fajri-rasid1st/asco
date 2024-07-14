// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/presentation/features/admin/meeting/providers/meeting_actions_provider.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final bool showDeleteButton;
  final VoidCallback? onTap;

  const MeetingCard({
    super.key,
    required this.meeting,
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
              '#${meeting.number}',
              style: textTheme.titleMedium!.copyWith(
                color: Palette.background,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${meeting.lesson}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall!.copyWith(
                    color: Palette.purple2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${meeting.date?.toDateTimeFormat('d MMMM yyyy')}',
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (showDeleteButton) ...[
            const SizedBox(width: 8),
            Consumer(
              builder: (context, ref, child) {
                return CircleBorderContainer(
                  size: 28,
                  borderColor: Palette.pink2,
                  fillColor: Palette.error,
                  onTap: () => context.showConfirmDialog(
                    title: 'Hapus Pertemuan?',
                    message: 'Anda yakin ingin menghapus pertemuan ini?',
                    primaryButtonText: 'Hapus',
                    onPressedPrimaryButton: () {
                      ref.read(meetingActionsProvider.notifier).deleteMeeting(meeting.id!);
                    },
                  ),
                  child: const Icon(
                    Icons.remove_rounded,
                    color: Palette.background,
                    size: 18,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
