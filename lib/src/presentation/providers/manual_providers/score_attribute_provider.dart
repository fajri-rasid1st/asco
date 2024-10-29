// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:asco/core/enums/model_attributes.dart';

final scoreAttributeProvider = StateProvider.autoDispose<ScoreAttribute>((ref) => ScoreAttribute.username);
