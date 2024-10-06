import 'package:flutter/material.dart';
import 'package:voice_poc/features/checksheets/models/m_check_sheet.dart';
import 'package:voice_poc/features/checksheets/services/s_checksheet.dart';
import 'package:voice_poc/features/text_to_speech/services/s_text_to_speech.dart';

class PreDeliveryServices extends CheckSheetService
    with TTSServices, ChangeNotifier {
  // Check list that displays the list of activities that need to be checked by the user
  List<MCheckSheet> _checkList = [];
  List<MCheckSheet> get checkList => _checkList;

  // Current active to check
  MCheckSheet? toCheck;
  set setToCheck(MCheckSheet? check) => setupToCheck(check);

  // Function to fetch the checklist
  Future getCheckList(String sku) async {
    _checkList = await getCheckSheetList(sku);

    notifyListeners();
    return;
  }

  // Method to initialize the inspection process
  Future initInspection() async {
    await super.initTTS();
  }

  // Narrat the selected option
  setupToCheck(MCheckSheet? check) async {
    toCheck = check;
    await super.narrateText(toCheck?.gROUP ?? 'End of inspection');
    notifyListeners();
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
