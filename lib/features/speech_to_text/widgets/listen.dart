import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_poc/features/checksheets/constants/c_key_prompts.dart';
import 'package:voice_poc/pages/02_home/s_home.dart';

class WDListen extends StatefulWidget {
  const WDListen({super.key, required this.service});
  final HomeServices service;

  @override
  State<WDListen> createState() => _WDListenState();
}

class _WDListenState extends State<WDListen> {
  SpeechToText? speech;
  bool _listenLoop = false;
  String lastHeard = '';
  StringBuffer totalHeard = StringBuffer();

  @override
  void didUpdateWidget(covariant WDListen oldWidget) {
    if (widget.service.toCheck == widget.service.checkList.last) {
      if (widget.service.checkList.last.status != null) {
        stopListening();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onStatus(String status) {
    if ('done' == status) {
      print('onStatus(): $status ');
      startListening();
    }
  }

  void startListening({bool forced = false}) async {
    if (forced) {
      setState(() {
        _listenLoop = !_listenLoop;
      });
    }
    if (!_listenLoop) return;
    print('startListening()');
    speech = SpeechToText();

    bool _available = await speech!.initialize(
      onStatus: _onStatus,
      //onError: (val) => print('onError: $val'),
      onError: (val) => onError(val),
      debugLogging: true,
    );
    if (_available) {
      print('startListening() -> _available = true');
      await listen();
    } else {
      print('startListening() -> _available = false');
    }
  }

  Future listen() async {
    speech!.listen(
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.search,
        enableHapticFeedback: true,
      ),
      onResult: (val) => onResult(val),
    ); // Doesn't do anything
  }

  void onError(SpeechRecognitionError val) async {
    print('onError(): ${val.errorMsg}');
  }

  void onResult(SpeechRecognitionResult val) async {
    print('onResult()');
    print(val.recognizedWords);

    if (val.finalResult) {
      if (val.recognizedWords == Keywords.passed.prompt.toLowerCase()) {
        widget.service.updateStatus(Keywords.passed.prompt);
      }
      if (val.recognizedWords == Keywords.failed.prompt.toLowerCase()) {
        widget.service.updateStatus(Keywords.failed.prompt);
      }
    }
  }

  stopListening() {
    speech?.stop();
    _listenLoop = false;
    return;
  }

  commenceFn() {
    //Set the first item in the list as active
    widget.service.setToCheck = widget.service.checkList.first;

    // Start listening to prompts
    widget.service.setIsStart = !widget.service.isStart;

    startListening(forced: true);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: commenceFn,
      child: Icon(
        _listenLoop ? Icons.mic : Icons.mic_external_off,
        size: 32,
      ),
    );
  }
}
