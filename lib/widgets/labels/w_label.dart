import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WDLabel extends StatelessWidget {
  const WDLabel({
    super.key,
    required this.label,
    this.isFlexible,
    this.style,
    this.textAlign,
    this.isExpanded,
  });
  final String label;
  final bool? isFlexible;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? isExpanded;

  @override
  Widget build(BuildContext context) {
    if (isFlexible == true) {
      return Flexible(child: AutoSizeText(label, style: style));
    }
    if (isExpanded == true) {
      return Expanded(child: AutoSizeText(label, style: style));
    }
    return AutoSizeText(
      label,
      style: style,
      textAlign: textAlign,
    );
  }
}
