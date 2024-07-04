// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lab_rule.freezed.dart';
part 'lab_rule.g.dart';

@freezed
class LabRule with _$LabRule {
  const factory LabRule({
    required int id,
    String? labRulePath,
    required int assistanceDelayMinimumPoints,
    required int assistanceDelayMaximumPoints,
    required int attendanceDelayMinimumPoints,
    required int attendanceDelayMaximumPoints,
  }) = _LabRule;

  factory LabRule.fromJson(Map<String, Object?> json) => _$LabRuleFromJson(json);
}
