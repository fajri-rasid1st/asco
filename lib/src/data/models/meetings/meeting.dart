// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';

part 'meeting.freezed.dart';
part 'meeting.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class Meeting with _$Meeting {
  const factory Meeting({
    String? id,
    int? number,
    String? lesson,
    @JsonKey(name: 'meetingDate') int? date,
    Profile? assistant,
    Profile? coAssistant,
    @JsonKey(name: 'module') String? modulePath,
    @JsonKey(name: 'assignment') String? assignmentPath,
    int? assistanceDeadline,
  }) = _Meeting;

  factory Meeting.fromJson(Map<String, Object?> json) => _$MeetingFromJson(json);
}
