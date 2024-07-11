// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

part 'score.freezed.dart';
part 'score.g.dart';

@freezed
class Score with _$Score {
  const factory Score({
    String? id,
    double? score,
    String? scoreType,
    Meeting? meeting,
    Profile? student,
  }) = _Score;

  factory Score.fromJson(Map<String, Object?> json) => _$ScoreFromJson(json);
}
