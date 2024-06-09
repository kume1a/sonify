class SelectOption<T> {
  SelectOption({
    required this.value,
    required this.label,
    required this.iconAssetName,
  });

  final T value;
  final String label;
  final String iconAssetName;
}
