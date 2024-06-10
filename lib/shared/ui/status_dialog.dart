import 'package:flutter/material.dart';

import '../../app/intl/app_localizations.dart';
import '../typedefs.dart';

class StatusDialog extends StatelessWidget {
  const StatusDialog({
    super.key,
    required this.content,
    required this.buttonLabel,
    this.onPressed,
  });

  final LocalizedStringResolver content;
  final LocalizedStringResolver buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 52, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              content(l),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () {
                onPressed?.call();
                Navigator.pop(context);
              },
              child: Text(buttonLabel(l)),
            ),
          ],
        ),
      ),
    );
  }
}
