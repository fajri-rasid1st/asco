extension EpochDateTime on DateTime {
  int get secondsSinceEpoch {
    return millisecondsSinceEpoch ~/ 1000;
  }
}
