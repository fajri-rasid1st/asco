// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:asco/core/extensions/datetime_extension.dart';

extension Capitalize on String {
  String toCapitalize([String separator = ' ']) {
    return split(separator).map((e) {
      return '${e.substring(0, 1).toUpperCase()}${e.substring(1, e.length).toLowerCase()}';
    }).join(separator);
  }
}

extension IntDateTime on String {
  int to24TimeFormat() {
    final parts = split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);

    return hours * 60 + minutes;
  }

  int toSecondsSinceEpoch() {
    final dateFormat = DateFormat('d/M/yyyy');
    final date = dateFormat.parse(this);

    return date.secondsSinceEpoch;
  }
}
