import 'package:flutter/material.dart';

ColorFilter svgColor(Color? color) {
  return ColorFilter.mode(color ?? Colors.transparent, BlendMode.srcIn);
}
