// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:asco/src/data/models/assistances/assistance.dart';
import 'package:asco/src/data/models/meetings/meeting.dart';
import 'package:asco/src/data/models/profiles/profile.dart';

part 'control_card.freezed.dart';
part 'control_card.g.dart';

@freezed
class ControlCard with _$ControlCard {
  const factory ControlCard({
    String? id,
    Meeting? meeting,
    Profile? student,
    Assistance? firstAssistance,
    Assistance? secondAssistance,
    bool? firstAssistanceStatus,
    bool? secondAssistanceStatus,
  }) = _ControlCard;

  factory ControlCard.fromJson(Map<String, Object?> json) => _$ControlCardFromJson(json);
}
