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
    const daysMap = {
      'SUNDAY': 'Minggu',
      'MONDAY': 'Senin',
      'TUESDAY': 'Selasa',
      'WEDNESDAY': 'Rabu',
      'THURSDAY': 'Kamis',
      'FRIDAY': 'Jum\'at',
      'SATURDAY': 'Sabtu'
    };

    return daysMap[day];
  }
}
