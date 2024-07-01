import 'package:flutter/material.dart';

class DefaultBackButton extends StatelessWidget {
  const DefaultBackButton({
    super.key,
    this.color,
    this.onPressed,
  });

  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return IconButton(
      icon: const BackButtonIcon(),
      color: color ?? theme.colorScheme.onSurface,
      splashRadius: 24,
      iconSize: 24,
      onPressed: onPressed ?? () => Navigator.maybePop(context),
    );
  }
}
