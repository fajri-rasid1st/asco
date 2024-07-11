// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lab_rule.freezed.dart';
part 'lab_rule.g.dart';

@freezed
class LabRule with _$LabRule {
  const factory LabRule({
    String? id,
    String? labRulePath,
    int? assistanceDelayMinimumPoints,
    int? assistanceDelayMaximumPoints,
    int? attendanceDelayMinimumPoints,
    int? attendanceDelayMaximumPoints,
  }) = _LabRule;

  factory LabRule.fromJson(Map<String, Object?> json) => _$LabRuleFromJson(json);
}
