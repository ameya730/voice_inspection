import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WDLabel extends StatelessWidget {
  const WDLabel({super.key, required this.label, this.isFlexible});
  final String label;
  final bool? isFlexible;

  @override
  Widget build(BuildContext context) {
    if (isFlexible == true) {
      return Flexible(child: AutoSizeText(label));
    }

    return AutoSizeText(label);
  }
}
