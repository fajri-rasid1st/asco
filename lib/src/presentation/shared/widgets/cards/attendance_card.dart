// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/core/utils/const.dart';
import 'package:asco/src/presentation/shared/widgets/circle_border_container.dart';
import 'package:asco/src/presentation/shared/widgets/ink_well_container.dart';

class AttendanceCard extends StatelessWidget {
  final bool locked;
  final AttendanceType attendanceType;
  final Map<String, int>? meetingStatus;
  final List<bool>? assistanceStatus;
  final VoidCallback? onTap;

  const AttendanceCard({
    super.key,
    this.locked = false,
    this.attendanceType = AttendanceType.meeting,
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
      onTap: onTap,
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
                    '#1',
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
                  'Tipe Data dan Attribute',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall!.copyWith(
                    color: locked ? Palette.disabledText : Palette.purple2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '26 Februari 2024',
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
                                    color: attendanceStatusColor[keys[index]]!,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                                      color: attendanceStatusColor[keys[index]]!,
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
            buildAssistanceStatus(
              isAttend: locked ? null : assistanceStatus!.first,
            ),
            const SizedBox(width: 4),
            buildAssistanceStatus(
              isAttend: locked ? null : assistanceStatus!.last,
            ),
          ],
        ],
      ),
    );
  }

  CircleBorderContainer buildAssistanceStatus({bool? isAttend}) {
    final borderColor = switch (isAttend) {
      true => Palette.purple2,
      false => Palette.pink2,
      null => null,
    };

    final fillColor = switch (isAttend) {
      true => Palette.success,
      false => Palette.error,
      null => null,
    };

    final icon = switch (isAttend) {
      true => Icons.check_rounded,
      false => Icons.close_rounded,
      null => null,
    };

    return CircleBorderContainer(
      size: 26,
      borderColor: borderColor,
      fillColor: fillColor,
      child: Icon(
        icon,
        color: Palette.background,
        size: isAttend == null ? null : 16,
      ),
    );
  }
}
