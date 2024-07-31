// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_meeting.freezed.dart';
part 'attendance_meeting.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class AttendanceMeeting with _$AttendanceMeeting {
  const factory AttendanceMeeting({
    String? meetingId,
    int? number,
    String? lesson,
    int? meetingDate,
    int? absent,
    int? sick,
    int? permission,
    int? attend,
  }) = _AttendanceMeeting;

  factory AttendanceMeeting.fromJson(Map<String, Object?> json) =>
      _$AttendanceMeetingFromJson(json);
}
