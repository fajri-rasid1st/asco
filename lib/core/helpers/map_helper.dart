class MapHelper {
  static int getRoleId(String? role) {
    final roleMap = {
      'ADMIN': 0,
      'STUDENT': 1,
      'ASSISTANT': 2,
    };

    return roleMap[role] ?? 0;
  }

  static String getReadableRole(String? role) {
    final roleMap = {
      'ADMIN': 'Admin',
      'STUDENT': 'Praktikan',
      'ASSISTANT': 'Asisten',
    };

    return roleMap[role] ?? '';
  }
}
