import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_poc/features/checksheets/services/s_checksheet.dart';
import 'package:voice_poc/features/checksheets/models/m_check_sheet.dart';

class HomeServices extends CheckSheetService with ChangeNotifier {
  // Basic loader

  // Check list that displays the list of activities that need to be checked by the user
  List<MCheckSheet> _checkList = [];
  List<MCheckSheet> get checkList => _checkList;

  // Variable to start listening to the user voice
  bool _isStart = false;
  bool get isStart => _isStart;
  set setIsStart(bool val) => _isStart = val;

  // Current active to check
  MCheckSheet? toCheck;
  set setToCheck(MCheckSheet? check) => setupToCheck(check);

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

  setupToCheck(MCheckSheet? check) async {
    toCheck = check;
    await narrateText();
    notifyListeners();
  }

  narrateText() async {
    print('The error is ${toCheck?.gROUP ?? 'Unable to understand'}');

    await flutterTts?.speak(
      toCheck?.gROUP ?? 'You have completed the inspection',
    );
    return;
  }

  // This function is used to update the status of the current checklist
  Future updateStatus(String status) async {
    // Update the status
    toCheck?.status = status;
    // Update the status for the object in the list
    int index = checkList.indexWhere((e) => e == toCheck!);
    checkList[index].status = status;
    // Check if it is the last item in the list or not
    // If not then move to the next list
    bool isLast = checkList.length - 1 == index;
    if (isLast == false) {
      setToCheck = checkList[index + 1];
    } else {
      setToCheck = null;
    }

    notifyListeners();
    return;
  }
}
