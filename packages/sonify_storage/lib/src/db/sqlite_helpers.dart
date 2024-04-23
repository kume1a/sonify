String sqlListPlaceholders(int length) {
  final String placeholders = List<String>.filled(length, '?').join(',');

  return '($placeholders)';
}
