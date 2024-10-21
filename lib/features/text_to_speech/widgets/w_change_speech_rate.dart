import 'package:flutter/material.dart';

class WDChangeSpeechRate extends StatefulWidget {
  const WDChangeSpeechRate({
    super.key,
    required this.val,
    required this.onChanged,
  });
  final double val;
  final void Function(double) onChanged;

  @override
  State<WDChangeSpeechRate> createState() => _WDChangeSpeechRateState();
}

class _WDChangeSpeechRateState extends State<WDChangeSpeechRate> {
  @override
  Widget build(BuildContext context) {
    return Slider(
      value: widget.val,
      onChanged: (value) => widget.onChanged(value),
      allowedInteraction: SliderInteraction.slideOnly,
      min: 0,
      max: 1,
    );
  }
}
