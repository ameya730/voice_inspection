import 'package:flutter/foundation.dart';
import 'package:voice_poc_other/features/text_to_speech/services/s_text_to_speech.dart';

class HomeServices with TTSServices, ChangeNotifier {
  test() async {
    await super.narrateText('Health is wealth');
  }
}
