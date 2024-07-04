// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/assistance_groups/assistance_group.dart';
import 'package:asco/src/data/models/classrooms/classroom.dart';
import 'package:asco/src/data/models/practicums/practicum.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required int id,
    required int userId,
    required String role,
    required String username,
    required String fullname,
    required String nickname,
    required String classOf,
    String? githubUsername,
    String? instagramUsername,
    String? profilePicturePath,
    List<Practicum>? practicums,
    List<Classroom>? classrooms,
    List<AssistanceGroup>? assistanceGroups,
  }) = _Profile;

  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);
}
