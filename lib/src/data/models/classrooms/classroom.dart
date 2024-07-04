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
    required int id,
    required String name,
    required String meetingDay,
    required int startTime,
    required int endTime,
    List<Profile>? students,
  }) = _Classroom;

  factory Classroom.fromJson(Map<String, Object?> json) => _$ClassroomFromJson(json);
}
