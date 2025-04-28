import 'package:flutter/material.dart';
import 'package:voice_poc_other/widgets/labels/w_label.dart';

class WDTitleLabel extends StatelessWidget {
  const WDTitleLabel({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return WDLabel(
      label: label,
      style: t.headlineLarge,
    );
  }
}
