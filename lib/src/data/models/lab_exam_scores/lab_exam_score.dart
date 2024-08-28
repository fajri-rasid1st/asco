// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

part 'lab_exam_score.freezed.dart';
part 'lab_exam_score.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class LabExamScore with _$LabExamScore {
  const factory LabExamScore({
    String? id,
    double? score,
    Practicum? practicum,
    Profile? student,
  }) = _LabExamScore;

  factory LabExamScore.fromJson(Map<String, Object?> json) => _$LabExamScoreFromJson(json);
}
