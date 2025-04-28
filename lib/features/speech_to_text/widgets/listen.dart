import 'package:flutter/material.dart';
import 'package:voice_poc_other/pages/02_home/s_home.dart';

class WDListen extends StatefulWidget {
  const WDListen({
    super.key,
    required this.service,
    required this.commence,
    required this.end,
  });
  final HomeServices service;
  final Function() commence;
  final Function() end;

  @override
  State<WDListen> createState() => _WDListenState();
}

class _WDListenState extends State<WDListen> {
  bool _recognitionStarted = false;

  toggle() {
    _recognitionStarted = !_recognitionStarted;
    if (_recognitionStarted) widget.commence();
    if (!_recognitionStarted) widget.end();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toggle,
      child: Icon(
        _recognitionStarted ? Icons.mic : Icons.mic_external_off,
        size: 32,
      ),
    );
  }
}
