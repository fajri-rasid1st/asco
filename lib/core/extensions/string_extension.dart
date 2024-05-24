extension Capitalize on String {
  String toCapitalize([String separator = ' ']) {
    return split(separator).map((e) {
      return '${e.substring(0, 1).toUpperCase()}${e.substring(1, e.length)}';
    }).join(separator);
  }
}
