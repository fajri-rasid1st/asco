// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/profiles/profile.dart';
import 'package:asco/src/data/models/scores/score.dart';

part 'score_recap.freezed.dart';
part 'score_recap.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class ScoreRecap with _$ScoreRecap {
  const factory ScoreRecap({
    String? practicumId,
    Profile? student,
    @JsonKey(name: 'assignmentScore') double? assignmentAverageScore,
    @JsonKey(name: 'quizScore') double? quizAverageScore,
    @JsonKey(name: 'responseScore') double? responseAverageScore,
    double? labExamScore,
    double? finalScore,
    List<Score>? assignmentScores,
    List<Score>? quizScores,
    List<Score>? responseScores,
  }) = _ScoreRecap;

  factory ScoreRecap.fromJson(Map<String, Object?> json) => _$ScoreRecapFromJson(json);
}
