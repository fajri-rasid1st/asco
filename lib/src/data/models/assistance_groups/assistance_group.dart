// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';

part 'assistance_group.freezed.dart';
part 'assistance_group.g.dart';

@freezed
class AssistanceGroup with _$AssistanceGroup {
  const factory AssistanceGroup({
    String? id,
    int? number,
    Profile? assistant,
    List<Profile>? students,
    String? githubRepositoryUrl,
  }) = _AssistanceGroup;

  factory AssistanceGroup.fromJson(Map<String, Object?> json) => _$AssistanceGroupFromJson(json);
}
