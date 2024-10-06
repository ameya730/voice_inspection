import 'package:flutter/material.dart';
import 'package:voice_poc/features/checksheets/constants/c_key_prompts.dart';
import 'package:voice_poc/pages/02_home/s_home.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

class WDListen extends StatefulWidget {
  const WDListen({super.key, required this.service});
  final HomeServices service;

  @override
  State<WDListen> createState() => _WDListenState();
}

class _WDListenState extends State<WDListen> {
  final _vosk = VoskFlutterPlugin.instance();

  String? _fileRecognitionResult;
  String? _error;
  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;

  bool _recognitionStarted = false;

  bool isPaused = false;

  @override
  void initState() {
    super.initState();

    setup();
  }

  setup() async {
    final enSmallModelPath = await ModelLoader().loadFromAssets(
      'assets/models/vosk-model-small-en-in-0.4.zip',
    );
    _model = await _vosk.createModel(enSmallModelPath);
    _recognizer = await _vosk.createRecognizer(
      model: _model!,
      sampleRate: 16000,
      grammar: ['verified', 'rejected'],
    );
  }

  @override
  void didUpdateWidget(covariant WDListen oldWidget) {
    if (widget.service.checkList.isNotEmpty) {
      if (widget.service.toCheck == widget.service.checkList.last) {
        if (widget.service.checkList.last.status != null) {
          stopFn();
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _speechService?.dispose();
    super.dispose();
  }

  commenceFn() async {
    //Set the first item in the list as active
    widget.service.setToCheck = widget.service.checkList.first;

    // Start listening to prompts
    widget.service.setIsStart = !widget.service.isStart;

    try {
      _speechService = await _vosk.initSpeechService(_recognizer!);
    } catch (e) {
      _speechService = _vosk.getSpeechService();
    }

    _speechService?.onResult().forEach((result) {
      print(result);
      if (result.contains('verified')) {
        widget.service.updateStatus(Keywords.passed.prompt);
      }
      if (result.contains('rejected')) {
        widget.service.updateStatus(Keywords.failed.prompt);
      }
    });

    await _speechService?.start();
    _recognitionStarted = true;

    if (mounted) setState(() {});
  }

  stopFn() async {
    _recognitionStarted = await _speechService?.stop() ?? false;
    _speechService?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          width: 200,
          child: Text(_error ?? _fileRecognitionResult ?? '-'),
        ),
        InkWell(
          onTap: commenceFn,
          child: Icon(
            _recognitionStarted ? Icons.mic : Icons.mic_external_off,
            size: 32,
          ),
        ),
      ],
    );
  }
}
