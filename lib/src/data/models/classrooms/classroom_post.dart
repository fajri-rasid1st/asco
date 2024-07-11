// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';

part 'classroom_post.freezed.dart';
part 'classroom_post.g.dart';

@freezed
class ClassroomPost with _$ClassroomPost {
  @JsonSerializable(includeIfNull: false)
  const factory ClassroomPost({
    required String name,
    required String meetingDay,
    required int startTime,
    required int endTime,
    List<Profile>? students,
  }) = _ClassroomPost;

  factory ClassroomPost.fromJson(Map<String, Object?> json) => _$ClassroomPostFromJson(json);
}
