// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';

part 'score.freezed.dart';
part 'score.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class Score with _$Score {
  const factory Score({
    String? id,
    double? score,
    double? assignmentScore,
    double? quizScore,
    double? responseScore,
    int? meetingNumber,
    String? meetingName,
    Profile? student,
  }) = _Score;

  factory Score.fromJson(Map<String, Object?> json) => _$ScoreFromJson(json);
}
