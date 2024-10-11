import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:voice_poc/features/checksheets/constants/c_key_prompts.dart';
import 'package:voice_poc/features/checksheets/models/m_check_sheet.dart';
import 'package:voice_poc/features/checksheets/services/s_checksheet.dart';
import 'package:voice_poc/features/speech_to_text/services/s_speech_to_text.dart';
import 'package:voice_poc/features/text_to_speech/services/s_text_to_speech.dart';

class PreDeliveryServices extends CheckSheetService
    with TTSServices, SpeechToTextServices, ChangeNotifier {
  // Scan a QR code to get the vehicle identification number
  String _sku = '';
  String get sku => _sku;
  set setSku(String str) {
    _sku = str;
    getCheckList(sku);
  }

  // Check list that displays the list of activities that need to be checked by the user
  List<MCheckSheet> _checkList = [];
  List<MCheckSheet> get checkList => _checkList;

  // Current active to check
  MCheckSheet? _toCheck;
  MCheckSheet? get toCheck => _toCheck;

  // Boolean to let the user know that the inspection is complete
  bool? isComplete;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  // Function to fetch the checklist
  Future getCheckList(String sku) async {
    _checkList = await getCheckSheetList(sku);

    notifyListeners();
    return;
  }

  // Method to initialize the inspection process
  Future initInspection() async {
    // When the user clicks on start inspection, first initialize text to speech services
    await super.initTTS();
    // Next initialize speech to text services
    await super.initSTTServices();

    // Set the to be checked item as the first one from the check list
    _toCheck = _checkList.first;
    notifyListeners();
    // Finally start listening to the result

    super.speechService?.onResult().forEach(
      (result) {
        print(result);
        if (result.contains('verified')) {
          updateStatus(Keywords.passed.prompt);
        }
        if (result.contains('rejected')) {
          updateStatus(Keywords.failed.prompt);
        }
        if (result.contains('rec on')) {
          _isRecording = true;
          notifyListeners();
        }
        if (result.contains('rec off')) {
          _isRecording = false;
          notifyListeners();
        }
      },
    );
    await super.speechService?.start();
    await setupToCheck();
  }

  // Narrat the selected option
  setupToCheck() async {
    String str = '';

    if (isComplete == true) {
      str = 'End of inspection';
    } else {
      str = _toCheck?.gROUP ?? '-';
    }

    await super.narrateText(str);
    notifyListeners();
    return;
  }

  // This function is used to update the status of the current checklist
  Future updateStatus(String status) async {
    // Update the status
    _toCheck?.status = status;
    // Update the status for the object in the list
    int index = checkList.indexWhere((e) => e == _toCheck!);
    checkList[index].status = status;

    // If the inspection has failed then the user needs to record a short description
    // that explains why the inspection has failed
    // At this point, pause the speech recogintion part and allow the user to record
    // the details

    // Pause speech services
    await super.speechService?.setPause(paused: true);

    // Prompt the user to wait for the beep
    await super.narrateText(
      'Please record the reason for rejection after the beep',
    );

    // Play the beep
    await AudioPlayer().play(AssetSource('assets/sounds/beep_sound.mp3'));

    // Once the user finishes recording the description un pause the speech recogniser
    // and continue with the inspection
    await super.speechService?.setPause(paused: false);

    moveToNextOrEnd();
  }

  moveToNextOrEnd() async {
    // Check if it is the last item in the list or not
    // If not then move to the next list
    int index = checkList.indexWhere((e) => e == _toCheck!);
    bool isLast = checkList.length - 1 == index;
    if (isLast == false) {
      _toCheck = checkList[index + 1];
      isComplete = false;
    } else {
      _toCheck = null;
      isComplete = true;
    }

    await setupToCheck();
  }

  disposeServices() async => await super.disposeSST();
}
