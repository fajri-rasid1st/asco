// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

class MapHelper {
  static Map<String, int> roleMap = {
    'ADMIN': 0,
    'STUDENT': 1,
    'ASSISTANT': 2,
  };

  static Map<String, String> readableRoleMap = {
    'ADMIN': 'Admin',
    'STUDENT': 'Praktikan',
    'ASSISTANT': 'Asisten',
  };

  static Map<String, String> dayMap = {
    'Minggu': 'SUNDAY',
    'Senin': 'MONDAY',
    'Selasa': 'TUESDAY',
    'Rabu': 'WEDNESDAY',
    'Kamis': 'THURSDAY',
    'Jum\'at': 'FRIDAY',
    'Sabtu': 'SATURDAY',
  };

  static Map<String, String> readableDayMap = {
    'SUNDAY': 'Minggu',
    'MONDAY': 'Senin',
    'TUESDAY': 'Selasa',
    'WEDNESDAY': 'Rabu',
    'THURSDAY': 'Kamis',
    'FRIDAY': 'Jum\'at',
    'SATURDAY': 'Sabtu'
  };

  static Map<String, String> attendanceMap = {
    'Hadir': 'ATTEND',
    'Alpa': 'ABSENT',
    'Sakit': 'SICK',
    'Izin': 'PERMISSION',
  };

  static Map<String, String> readableAttendanceMap = {
    'ATTEND': 'Hadir',
    'ABSENT': 'Alpa',
    'SICK': 'Sakit',
    'PERMISSION': 'Izin',
  };

  static Map<String, Color> attendanceColorMap = {
    'ATTEND': Palette.success,
    'ABSENT': Palette.error,
    'SICK': Palette.warning,
    'PERMISSION': Palette.info,
  };

  static Map<String, Color> readableAttendanceColorMap = {
    'Hadir': Palette.success,
    'Alpa': Palette.error,
    'Sakit': Palette.warning,
    'Izin': Palette.info,
    'Selesai': Palette.success,
    'Belum': Palette.error,
  };

  static Map<String, String> roleFilterMap = {
    'Semua': '',
    'Praktikan': 'STUDENT',
    'Asisten': 'ASSISTANT',
  };
}
