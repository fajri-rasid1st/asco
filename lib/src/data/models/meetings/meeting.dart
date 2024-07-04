// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';

part 'meeting.freezed.dart';
part 'meeting.g.dart';

@freezed
class Meeting with _$Meeting {
  const factory Meeting({
    required int id,
    required int number,
    required String lesson,
    required int date,
    required int assistanceDeadline,
    required Profile assistant1,
    required Profile assistant2,
    String? modulePath,
    String? assignmentPath,
  }) = _Meeting;

  factory Meeting.fromJson(Map<String, Object?> json) => _$MeetingFromJson(json);
}
