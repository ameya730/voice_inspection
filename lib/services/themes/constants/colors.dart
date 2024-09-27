import 'package:flutter/material.dart';

enum AppColors {
  primary(Color(0xFF2073DF)),
  disabled(Colors.grey),
  titleMidGray(Colors.blueGrey),
  hintColor(Color(0xFFB0AFAF)),
  black(Colors.black);

  final Color color;
  const AppColors(this.color);
}
