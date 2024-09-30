// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_post.freezed.dart';
part 'score_post.g.dart';

@freezed
class ScorePost with _$ScorePost {
  @JsonSerializable(includeIfNull: false)
  const factory ScorePost({
    required String studentId,
    required double score,
    required String type,
  }) = _ScorePost;

  factory ScorePost.fromJson(Map<String, Object?> json) => _$ScorePostFromJson(json);
}
