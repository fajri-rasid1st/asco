extension ModifiedIterable<T> on Iterable<T> {
  List<T> sortedBy(Comparable Function(T e) key, {bool asc = true}) {
    return toList()..sort((a, b) => key(a).compareTo(key(b)) * (asc ? 1 : -1));
  }
}
