// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';

part 'classroom.freezed.dart';
part 'classroom.g.dart';

@freezed
class Classroom with _$Classroom {
  const factory Classroom({
    String? id,
    String? name,
    String? meetingDay,
    int? startTime,
    int? endTime,
    List<Profile>? students,
    int? totalStudents,
  }) = _Classroom;

  factory Classroom.fromJson(Map<String, Object?> json) => _$ClassroomFromJson(json);
}
