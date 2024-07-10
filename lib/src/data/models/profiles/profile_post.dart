// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_post.freezed.dart';
part 'profile_post.g.dart';

@freezed
class ProfilePost with _$ProfilePost {
  @JsonSerializable(includeIfNull: false)
  const factory ProfilePost({
    required String username,
    required String fullname,
    required String classOf,
    required String role,
    String? password,
  }) = _ProfilePost;

  factory ProfilePost.fromJson(Map<String, Object?> json) => _$ProfilePostFromJson(json);
}
