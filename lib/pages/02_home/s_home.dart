import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:voice_poc/features/checksheets/c_checksheet.dart';
import 'package:voice_poc/features/checksheets/models/m_check_sheet.dart';

class HomeServices extends CheckSheetService with ChangeNotifier {
  // Basic loader

  // Check list that displays the list of activities that need to be checked by the user
  List<MCheckSheet> _checkList = [];
  List<MCheckSheet> get checkList => _checkList;

  // Current active to check
  MCheckSheet? toCheck;
  set setToCheck(MCheckSheet? check) {
    toCheck = check;
    narrateText();
  }

  // Variable to text to speech
  FlutterTts? flutterTts;

  Future getCheckList(String sku) async {
    _checkList = await getCheckSheetList(sku);

    flutterTts = FlutterTts();
    await flutterTts?.setLanguage("en-US");
    await flutterTts?.setSpeechRate(0.3);
    await flutterTts?.setPitch(1);

    notifyListeners();
    return;
  }

  narrateText() async => await flutterTts?.speak(
        toCheck?.gROUP ?? 'Unable to understand',
      );
}
