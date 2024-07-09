// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/assistance_groups/assistance_group.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

part 'practicum.freezed.dart';
part 'practicum.g.dart';

@freezed
class Practicum with _$Practicum {
  const factory Practicum({
    String? id,
    String? course,
    @JsonKey(name: 'badge') String? badgePath,
    @JsonKey(name: 'courseContract') String? courseContractPath,
    String? examInfo,
    List<Classroom>? classrooms,
    List<Meeting>? meetings,
    List<Profile>? assistants,
    List<AssistanceGroup>? assistanceGroups,
    int? classroomsLength,
  }) = _Practicum;

  factory Practicum.fromJson(Map<String, Object?> json) => _$PracticumFromJson(json);
}
