// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    String? id,
    String? profileId,
    String? role,
    String? username,
    String? fullname,
    String? nickname,
    String? classOf,
    String? githubUsername,
    String? instagramUsername,
    @JsonKey(name: 'profilePic') String? profilePicturePath,
  }) = _Profile;

  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);
}
