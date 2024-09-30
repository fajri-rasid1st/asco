// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rive/rive.dart';

// Project imports:
import 'package:asco/core/enums/attendance_type.dart';
import 'package:asco/core/helpers/asset_path.dart';
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/core/styles/text_style.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

class AttendanceStatusDialog extends StatelessWidget {
  final Profile student;
  final Meeting meeting;
  final AttendanceType attendanceType;
  final bool isAttend;

  const AttendanceStatusDialog({
    super.key,
    required this.student,
    required this.meeting,
    required this.attendanceType,
    required this.isAttend,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.fromLTRB(32, 56, 32, 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: -130,
            child: SizedBox(
              width: 250,
              height: 250,
              child: RiveAnimation.asset(
                AssetPath.getRive(
                  isAttend ? 'checkmark_icon.riv' : 'error_icon.riv',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 68, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${meeting.lesson}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  attendanceType == AttendanceType.meeting
                      ? 'Pertemuan ${meeting.number}'
                      : 'Asistensi ${meeting.number}',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge!.copyWith(
                    color: Palette.purple2,
                  ),
                ),
                Text(
                  isAttend ? 'Hadir' : 'Tidak Hadir',
                  textAlign: TextAlign.center,
                  style: textTheme.titleSmall!.copyWith(
                    color: isAttend ? Palette.success : Palette.error,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  '${student.fullname}',
                  textAlign: TextAlign.center,
                  style: textTheme.titleSmall!.copyWith(
                    color: Palette.purple2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${student.username}',
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall!.copyWith(
                    color: Palette.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
