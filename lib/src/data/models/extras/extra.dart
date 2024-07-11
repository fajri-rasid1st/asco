// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'extra.freezed.dart';
part 'extra.g.dart';

@freezed
class Extra with _$Extra {
  const factory Extra({
    String? id,
    String? quizUrl,
    String? questionnaireUrl,
  }) = _Extra;

  factory Extra.fromJson(Map<String, Object?> json) => _$ExtraFromJson(json);
}
