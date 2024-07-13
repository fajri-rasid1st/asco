// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'practicum_post.freezed.dart';
part 'practicum_post.g.dart';

@freezed
class PracticumPost with _$PracticumPost {
  @JsonSerializable(includeIfNull: false)
  const factory PracticumPost({
    required String course,
    @JsonKey(name: 'badge') required String badgePath,
    @JsonKey(name: 'courseContract') String? courseContractPath,
    String? examInfo,
  }) = _PracticumPost;

  factory PracticumPost.fromJson(Map<String, Object?> json) => _$PracticumPostFromJson(json);
}
