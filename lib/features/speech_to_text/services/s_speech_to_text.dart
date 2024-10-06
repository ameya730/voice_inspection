import 'package:vosk_flutter/vosk_flutter.dart';

mixin SpeechToTextServices {
  final _vosk = VoskFlutterPlugin.instance();
  String? _fileRecognitionResult;
  String? _error;
  Model? _model;
  Recognizer? _recognizer;
  SpeechService? _speechService;
  bool _recognitionStarted = false;
  bool isPaused = false;

  Future initSTTServices() async {
    final enSmallModelPath = await ModelLoader().loadFromAssets(
      'assets/models/vosk-model-small-en-in-0.4.zip',
    );
    _model = await _vosk.createModel(enSmallModelPath);
    _recognizer = await _vosk.createRecognizer(
      model: _model!,
      sampleRate: 16000,
      grammar: ['verified', 'rejected'],
    );
    try {
      _speechService = await _vosk.initSpeechService(_recognizer!);
    } catch (e) {
      _speechService = _vosk.getSpeechService();
    }
  }
}
