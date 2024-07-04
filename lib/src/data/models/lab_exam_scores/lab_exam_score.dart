// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/practicums/practicum.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

part 'lab_exam_score.freezed.dart';
part 'lab_exam_score.g.dart';

@freezed
class LabExamScore with _$LabExamScore {
  const factory LabExamScore({
    required int id,
    required double score,
    required Practicum practicum,
    required Profile student,
  }) = _LabExamScore;

  factory LabExamScore.fromJson(Map<String, Object?> json) => _$LabExamScoreFromJson(json);
}
