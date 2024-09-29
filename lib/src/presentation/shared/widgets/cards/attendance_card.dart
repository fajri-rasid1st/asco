// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/extensions/number_extension.dart';
import 'package:asco/core/helpers/map_helper.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/presentation/shared/widgets/assistance_status_icon.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';

class AttendanceCard extends StatelessWidget {
  final Meeting meeting;
  final AttendanceType attendanceType;
  final bool locked;
  final Map<String, int>? meetingStatus;
  final List<bool>? assistanceStatus;
  final VoidCallback? onTap;

  const AttendanceCard({
    super.key,
    required this.meeting,
    this.attendanceType = AttendanceType.meeting,
    this.locked = false,
    this.meetingStatus,
    this.assistanceStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!locked) {
      if (attendanceType == AttendanceType.meeting) {
        assert(meetingStatus != null && meetingStatus!.length <= 4);
      } else {
        assert(assistanceStatus != null && assistanceStatus!.length <= 2);
      }
    }

    return InkWellContainer(
      radius: 12,
      color: Palette.background,
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 12,
      ),
      onTap: locked ? null : onTap,
      child: Row(
        crossAxisAlignment: attendanceType == AttendanceType.meeting
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          CircleBorderContainer(
            size: 54,
            borderWidth: 1.5,
            child: locked
                ? const Icon(
                    Icons.lock_outline_rounded,
                    color: Palette.disabledText,
                  )
                : Text(
                    '#${meeting.number}',
                    style: textTheme.titleMedium!.copyWith(
                      color: Palette.disabledText,
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
                    color: locked ? Palette.disabledText : Palette.purple2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${meeting.date?.toDateTimeFormat('d MMMM yyyy')}',
                  style: textTheme.bodySmall!.copyWith(
                    color: locked ? Palette.disabledText : Palette.secondaryText,
                  ),
                ),
                if (!locked && attendanceType == AttendanceType.meeting)
                  Builder(
                    builder: (context) {
                      final keys = meetingStatus!.keys.toList();
                      final values = meetingStatus!.values.toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!values.every((e) => e == 0)) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: List<Expanded>.generate(
                                meetingStatus!.length,
                                (index) => Expanded(
                                  flex: values[index],
                                  child: Container(
                                    height: 6,
                                    margin: EdgeInsets.only(
                                      right: index == meetingStatus!.length ? 0 : 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MapHelper.readableAttendanceColorMap[keys[index]]!,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Row(
                            children: List<Flexible>.generate(
                              meetingStatus!.length,
                              (index) => Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: index == meetingStatus!.length ? 0 : 6,
                                  ),
                                  child: Text(
                                    '${values[index]} ${keys[index]}',
                                    style: textTheme.labelSmall!.copyWith(
                                      color: MapHelper.readableAttendanceColorMap[keys[index]]!,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
          if (attendanceType == AttendanceType.assistance) ...[
            const SizedBox(width: 8),
            AssistanceStatusIcon(
              isAttend: locked ? null : assistanceStatus!.first,
            ),
            const SizedBox(width: 4),
            AssistanceStatusIcon(
              isAttend: locked ? null : assistanceStatus!.last,
            ),
          ],
        ],
      ),
    );
  }
}
