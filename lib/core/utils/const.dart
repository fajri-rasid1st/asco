// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

// const error messages
const kNoInternetConnection = 'no internet connection';
const kNoAuthorization = 'Provide Authorization in header';
const kAuthorizationExpired = 'jwt expired';
const kAuthorizationError = 'token is not formed correctly. JWT format is xxxx.yyyyy.zzzz';
const kUserNotFound = 'user\'s not found';
const kIncorrectPassword = 'password is incorrect';

// const shared preferences keys
const accessTokenKey = 'ACCESS_TOKEN';
const credentialKey = 'CREDENTIAL';

// another consts
const roleId = 2; // 0 admin, 1 student, 2 assistant

const userRoleFilter = {
  'Semua': '',
  'Praktikan': 'STUDENT',
  'Asisten': 'ASSISTANT',
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
