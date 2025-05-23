import 'package:flutter/material.dart';
import 'package:vosk_flutter/vosk_flutter.dart';

mixin SpeechToTextServices {
  final _vosk = VoskFlutterPlugin.instance();
  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;
  SpeechService? get speechService => _speechService;

  Future initSTTServices() async {
    final enSmallModelPath = await ModelLoader().loadFromAssets(
      'assets/models/vosk-model-small-en-in-0.4.zip',
    );
    _model = await _vosk.createModel(enSmallModelPath);
    _recognizer = await _vosk.createRecognizer(
      model: _model!,
      sampleRate: 16000,
      grammar: ['verified', 'rejected', 'rec on', 'rec off'],
    );

    try {
      _speechService = await _vosk.initSpeechService(_recognizer!);
    } catch (e) {
      _speechService = _vosk.getSpeechService();
    }
  }

  Future<void> pauseSpeech() async {
    await _speechService?.setPause(paused: true);
  }

  Future<void> resumeSpeech() async {
    await _speechService?.setPause(paused: false);
  }

  Future disposeSST() async {
    try {
      await _speechService?.setPause(paused: true);
      await _speechService?.stop();
      await _speechService?.dispose();
      await _recognizer?.dispose();
    } catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }
}
