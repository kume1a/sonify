import 'package:coin_grab/coin_grab.dart';
import 'package:flutter/material.dart';

class CoinGrabPage extends StatelessWidget {
  const CoinGrabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CoinGrabWidget(
      onGoBack: () => Navigator.of(context).pop(),
    );
  }
}
