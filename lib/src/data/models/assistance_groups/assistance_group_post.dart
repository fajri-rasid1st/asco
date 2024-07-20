// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistance_group_post.freezed.dart';
part 'assistance_group_post.g.dart';

@freezed
class AssistanceGroupPost with _$AssistanceGroupPost {
  @JsonSerializable(includeIfNull: false)
  const factory AssistanceGroupPost({
    required int number,
    @JsonKey(name: 'mentor') required String assistantId,
    @JsonKey(name: 'mentees') required List<String> studentIds,
    String? githubRepoLink,
  }) = _AssistanceGroupPost;

  factory AssistanceGroupPost.fromJson(Map<String, Object?> json) =>
      _$AssistanceGroupPostFromJson(json);
}
