// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistance.freezed.dart';
part 'assistance.g.dart';

@freezed
class Assistance with _$Assistance {
  const factory Assistance({
    String? id,
    bool? status,
    int? datetime,
    String? note,
  }) = _Assistance;

  factory Assistance.fromJson(Map<String, Object?> json) => _$AssistanceFromJson(json);
}
