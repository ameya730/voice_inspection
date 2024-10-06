import 'package:flutter_tts/flutter_tts.dart';

mixin TTSServices {
  FlutterTts? flutterTts;

  // Initialize text to speech
  Future initTTS() async {
    await flutterTts?.setLanguage("en-US");
    await flutterTts?.setSpeechRate(0.3);
    await flutterTts?.setPitch(1);
    return;
  }

  // Method to narrate text
  narrateText(String str) async {
    await flutterTts?.speak(str);
    return;
  }
}
