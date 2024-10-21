import 'package:flutter_tts/flutter_tts.dart';

mixin TTSServices {
  FlutterTts? flutterTts;
  static double speechRate = 0.3;
  double get getSpeechRate => speechRate;

  // Initialize text to speech
  Future initTTS() async {
    flutterTts = FlutterTts();
    await flutterTts?.setLanguage("en-US");
    await flutterTts?.setSpeechRate(speechRate);
    await flutterTts?.setPitch(1);
    return;
  }

  // Method to narrate text
  Future<void> narrateText(String str) async {
    await flutterTts?.speak(str);
  }

  Future<void> setSpeechRate(double val) async {
    speechRate = val;
    await flutterTts?.setSpeechRate(val);
    return;
  }
}
