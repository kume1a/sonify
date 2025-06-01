import 'package:flutter/material.dart';
import 'package:global_navigator/global_navigator.dart';

ThemeData? getStaticTheme() {
  final c = GlobalNavigator.context;

  return c != null ? Theme.of(c) : null;
}
