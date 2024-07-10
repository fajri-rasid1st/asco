// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/extensions/context_extension.dart';
import 'package:asco/core/routes/route_names.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/keys.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/presentation/features/admin/practicum/providers/practicum_actions_provider.dart';
import 'package:asco/src/presentation/shared/pages/select_classroom_page.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';
import 'package:asco/src/presentation/shared/widgets/practicum_badge_image.dart';

class PracticumCard extends StatelessWidget {
  final Practicum practicum;
  final bool showDeleteButton;
  final bool showClassroomAndMeetingButtons;
  final VoidCallback? onTap;

  const PracticumCard({
    super.key,
    required this.practicum,
    this.showDeleteButton = false,
    this.showClassroomAndMeetingButtons = false,
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
      child: Column(
        children: [
          Row(
            children: [
              PracticumBadgeImage(
                badgeUrl: '${practicum.badgePath}',
                width: 48,
                height: 52,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${practicum.course}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall!.copyWith(
                        color: Palette.purple2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${practicum.classroomsLength} Kelas',
                            style: textTheme.bodySmall!.copyWith(
                              color: Palette.purple3,
                            ),
                          ),
                        ),
                        if (showClassroomAndMeetingButtons) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: CircleBorderContainer(
                              size: 3,
                              withBorder: false,
                              fillColor: Palette.purple3,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '10 Pertemuan',
                              style: textTheme.bodySmall!.copyWith(
                                color: Palette.purple3,
                              ),
                            ),
                          ),
                        ],
                      ],
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
                        title: 'Hapus Praktikum?',
                        message: 'Anda yakin ingin menghapus praktikum ini?',
                        primaryButtonText: 'Hapus',
                        onPressedPrimaryButton: () {
                          ref
                              .read(practicumActionsProvider.notifier)
                              .deletePracticum(practicum.id!)
                              .whenComplete(() => navigatorKey.currentState!.pop());
                        },
                      ),
                      child: const Icon(
                        Icons.remove_rounded,
                        size: 18,
                        color: Palette.background,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
          if (showClassroomAndMeetingButtons) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => navigatorKey.currentState!.pushNamed(
                      selectClassroomRoute,
                      arguments: SelectClassroomPageArgs(
                        title: 'Pemrograman Mobile',
                        onItemTapped: () => navigatorKey.currentState!.pushNamed(
                          classroomDetailRoute,
                        ),
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Palette.secondary,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('Kelas'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => navigatorKey.currentState!.pushNamed(meetingListHomeRoute),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('Pertemuan'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
