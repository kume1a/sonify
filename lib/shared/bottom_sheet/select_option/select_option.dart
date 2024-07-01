import '../../typedefs.dart';

class SelectOption<T> {
  SelectOption({
    required this.value,
    required this.label,
    this.iconAssetName,
    this.isActive = true,
  });

  final T value;
  final LocalizedStringResolver label;
  final String? iconAssetName;
  final bool isActive;
}
