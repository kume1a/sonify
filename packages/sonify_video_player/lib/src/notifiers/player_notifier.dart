import 'package:flutter/material.dart';

class PlayerNotifier extends ChangeNotifier {
  PlayerNotifier() : _hideStuff = true;

  bool _hideStuff;

  bool get hideStuff => _hideStuff;

  set hideStuff(bool value) {
    _hideStuff = value;
    notifyListeners();
  }
}
