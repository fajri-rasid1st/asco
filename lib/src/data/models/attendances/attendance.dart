// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

part 'attendance.freezed.dart';
part 'attendance.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class Attendance with _$Attendance {
  const factory Attendance({
    String? id,
    Meeting? meeting,
    Profile? student,
    @JsonKey(name: 'attendanceStatus') String? status,
    int? time,
    String? note,
    int? extraPoint,
  }) = _Attendance;

  factory Attendance.fromJson(Map<String, Object?> json) => _$AttendanceFromJson(json);
}
