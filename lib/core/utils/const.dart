// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

// const item per page
const kPageLimit = 20;

// const error messages
const kUnauthorized = 'UNAUTHORIZED';

// const shared preferences keys
const accessTokenKey = 'ACCESS_TOKEN';
const userCredentialKey = 'USER_CREDENTIAL';

// another consts
const roleId = 2; // 0 admin, 1 student, 2 assistant

const userRoleFilter = {
  'Semua': '',
  'Praktikan': 'student',
  'Asisten': 'assistant',
};

const dayOfWeek = {
  'Minggu': 'sunday',
  'Senin': 'monday',
  'Selasa': 'tuesday',
  'Rabu': 'wednesday',
  'Kamis': 'thursday',
  'Jum\'at': 'friday',
  'Sabtu': 'saturday',
};

const attendanceStatus = {
  'Hadir': 'present',
  'Alpa': 'absent',
  'Sakit': 'sick',
  'Izin': 'excused',
};

const attendanceStatusColor = {
  'Hadir': Palette.success,
  'Alpa': Palette.error,
  'Sakit': Palette.warning,
  'Izin': Palette.info,
  'Selesai': Palette.success,
  'Belum': Palette.error,
};
