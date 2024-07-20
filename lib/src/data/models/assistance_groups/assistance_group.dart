// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';

part 'assistance_group.freezed.dart';
part 'assistance_group.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class AssistanceGroup with _$AssistanceGroup {
  const factory AssistanceGroup({
    String? id,
    int? number,
    Profile? assistant,
    String? assistantName,
    List<Profile>? students,
    int? studentsCount,
    String? githubRepoLink,
  }) = _AssistanceGroup;

  factory AssistanceGroup.fromJson(Map<String, Object?> json) => _$AssistanceGroupFromJson(json);
}
