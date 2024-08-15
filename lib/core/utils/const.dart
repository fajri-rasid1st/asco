// Project imports:
import 'package:asco/core/styles/color_scheme.dart';

// const error messages
const kNoInternetConnection = 'no internet connection';
const kUnauthorized = 'you are not authorized';
const kNoAuthorization = 'Provide Authorization in header';
const kAuthorizationExpired = 'jwt expired';
const kAuthorizationError = 'token is not formed correctly. JWT format is xxxx.yyyyy.zzzz';
const kUserNotFound = 'user\'s not found';
const kIncorrectPassword = 'password is incorrect';
const kClassroomsEmpty = '"classrooms" must contain at least 1 items';
const kAssistantsEmpty = '"assistants" must contain at least 1 items';
const kStudentsEmpty = '"students" must contain at least 1 items';
const kMenteesEmpty = '"mentees" must contain at least 1 items';
const kStudentsAlreadyExists =
    'cannot assign student to this classroom has been assigned to another classroom in this practicum';

// const shared preferences keys
const accessTokenKey = 'ACCESS_TOKEN';
const credentialKey = 'CREDENTIAL';

// another consts
const userRoleFilter = {
  'Semua': '',
  'Praktikan': 'STUDENT',
  'Asisten': 'ASSISTANT',
};

const dayOfWeek = {
  'Minggu': 'SUNDAY',
  'Senin': 'MONDAY',
  'Selasa': 'TUESDAY',
  'Rabu': 'WEDNESDAY',
  'Kamis': 'THURSDAY',
  'Jum\'at': 'FRIDAY',
  'Sabtu': 'SATURDAY',
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
