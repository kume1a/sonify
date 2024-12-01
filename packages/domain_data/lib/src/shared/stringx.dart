extension StringX on String? {
  bool get notNullOrEmpty => this != null && this?.isNotEmpty == true;

  bool get isNullOrEmpty => this == null || this?.isEmpty == true;
}
