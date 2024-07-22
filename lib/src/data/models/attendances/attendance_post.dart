// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_post.freezed.dart';
part 'attendance_post.g.dart';

@freezed
class AttendancePost with _$AttendancePost {
  @JsonSerializable(includeIfNull: false)
  const factory AttendancePost({
    @JsonKey(name: 'profileId') required String studentId,
    @JsonKey(name: 'attendanceStatus') required String status,
    String? note,
    int? extraPoint,
  }) = _AttendancePost;

  factory AttendancePost.fromJson(Map<String, Object?> json) => _$AttendancePostFromJson(json);
}
