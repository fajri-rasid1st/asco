// Project imports:
import 'package:asco/core/styles/color_scheme.dart';
import 'package:asco/src/presentation/shared/widgets/dialogs/practicum_score_dialog.dart';

// const item per page
const kPageLimit = 20;

// const error messages
const kUnauthorized = 'UNAUTHORIZED';

// const shared preferences keys
const accessTokenKey = 'ACCESS_TOKEN';
const userCredentialKey = 'USER_CREDENTIAL';

// another consts
const userRole = {
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
  'Alpa': 'absent',
  'Izin': 'excused',
  'Sakit': 'sick',
  'Hadir': 'present',
};

const practicumScoreTypes = [
  PracticumScoreType(1, Palette.errorText, 50.0, "Sangat Rendah"),
  PracticumScoreType(2, Palette.error, 65.0, "Rendah"),
  PracticumScoreType(3, Palette.warning, 75.0, "Cukup"),
  PracticumScoreType(4, Palette.info, 80.0, "Sedang"),
  PracticumScoreType(5, Palette.info, 85.0, "Lumayan"),
  PracticumScoreType(6, Palette.success, 92.0, "Bagus"),
  PracticumScoreType(7, Palette.success, 98.0, "Sangat Bagus"),
];
