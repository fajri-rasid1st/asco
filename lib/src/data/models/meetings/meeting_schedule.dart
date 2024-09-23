// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_schedule.freezed.dart';
part 'meeting_schedule.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class MeetingSchedule with _$MeetingSchedule {
  const factory MeetingSchedule({
    String? id,
    int? number,
    String? lesson,
    @JsonKey(name: 'meetingDate') int? date,
    @JsonKey(name: 'assistant') bool? asMain,
  }) = _MeetingSchedule;

  factory MeetingSchedule.fromJson(Map<String, Object?> json) => _$MeetingScheduleFromJson(json);
}
