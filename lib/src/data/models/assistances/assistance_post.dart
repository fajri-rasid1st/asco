// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistance_post.freezed.dart';
part 'assistance_post.g.dart';

@freezed
class AssistancePost with _$AssistancePost {
  @JsonSerializable(includeIfNull: false)
  const factory AssistancePost({
    required bool status,
    required int date,
    String? note,
  }) = _AssistancePost;

  factory AssistancePost.fromJson(Map<String, Object?> json) => _$AssistancePostFromJson(json);
}
