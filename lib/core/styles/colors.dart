import 'package:flutter/material.dart';

class AppColors {
  static const light = _LightColors();
  static const dark = _DarkColors();
}

class _LightColors {
  const _LightColors();

  final Color white = Colors.white;
  final Color staticWhite = Colors.white;
  final Color lightWhite = Colors.white;
  final Color grey = const Color(0xFFF2F2F2);
  final Color black = const Color(0xFF222222);
  final Color staticBlack = const Color(0xFF222222);
  final Color blue = const Color(0xFF3772FF);
  final Color error = const Color(0xFFDC3545);
}

class _DarkColors {
  const _DarkColors();

  final Color white = const Color(0xFF222222);
  final Color staticWhite = Colors.white;
  final Color lightWhite = const Color(0xFF575757);
  final Color grey = const Color(0xFF363636);
  final Color black = Colors.white;
  final Color staticBlack = const Color(0xFF222222);
  final Color blue = const Color(0xFF7BBDF7);
  final Color error = const Color(0xFFFF9AA1);
}
