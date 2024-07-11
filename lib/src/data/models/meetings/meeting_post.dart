// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_post.freezed.dart';
part 'meeting_post.g.dart';

@freezed
class MeetingPost with _$MeetingPost {
  @JsonSerializable(includeIfNull: false)
  const factory MeetingPost({
    required int number,
    required String lesson,
    @JsonKey(name: 'meetingDate') required int date,
    @JsonKey(name: 'assistant') required String assistantId,
    @JsonKey(name: 'coAssistant') required String coAssistantId,
    String? modulePath,
    String? assignmentPath,
    int? assistanceDeadline,
  }) = _MeetingPost;

  factory MeetingPost.fromJson(Map<String, Object?> json) => _$MeetingPostFromJson(json);
}
