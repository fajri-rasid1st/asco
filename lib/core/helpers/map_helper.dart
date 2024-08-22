// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

class MapHelper {
  static int? getRoleId(String? role) {
    final roleMap = {
      'ADMIN': 0,
      'STUDENT': 1,
      'ASSISTANT': 2,
    };

    return roleMap[role];
  }

  static String? getReadableRole(String? role) {
    final roleMap = {
      'ADMIN': 'Admin',
      'STUDENT': 'Praktikan',
      'ASSISTANT': 'Asisten',
    };

    return roleMap[role];
  }

  static String? getReadableDay(String? day) {
    const dayMap = {
      'SUNDAY': 'Minggu',
      'MONDAY': 'Senin',
      'TUESDAY': 'Selasa',
      'WEDNESDAY': 'Rabu',
      'THURSDAY': 'Kamis',
      'FRIDAY': 'Jum\'at',
      'SATURDAY': 'Sabtu'
    };

    return dayMap[day];
  }

  static String? getReadableAttendanceStatus(String? attendanceStatus) {
    final attendanceStatusMap = {
      'ATTEND': 'Hadir',
      'ABSENT': 'Alpa',
      'SICK': 'Sakit',
      'PERMISSION': 'Izin',
    };

    return attendanceStatusMap[attendanceStatus];
  }

  static Color? getAttendanceStatusColor(String? attendanceStatus) {
    const attendanceStatusColorMap = {
      'ATTEND': Palette.success,
      'ABSENT': Palette.error,
      'SICK': Palette.warning,
      'PERMISSION': Palette.info,
    };

    return attendanceStatusColorMap[attendanceStatus];
  }
}
