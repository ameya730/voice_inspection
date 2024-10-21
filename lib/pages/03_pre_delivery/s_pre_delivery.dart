import 'package:flutter/material.dart';
import 'package:voice_poc/features/checksheets/constants/c_key_prompts.dart';
import 'package:voice_poc/features/checksheets/models/m_check_sheet.dart';
import 'package:voice_poc/features/checksheets/models/m_check_sheet_details.dart';
import 'package:voice_poc/features/checksheets/services/s_checksheet.dart';
import 'package:voice_poc/features/record/services/s_record.dart';
import 'package:voice_poc/features/speech_to_text/services/s_speech_to_text.dart';
import 'package:voice_poc/features/text_to_speech/services/s_text_to_speech.dart';
import 'package:voice_poc/features/vin/services/s_vin.dart';

class PreDeliveryServices extends CheckSheetService
    with
        TTSServices,
        SpeechToTextServices,
        RecordServices,
        VinMixin,
        ChangeNotifier {
  // Scan a QR code to get the vehicle identification number
  String _vin = '';
  String get vin => _vin;
  set setVin(String str) {
    _vin = str;
    // Make the api call to fetch the sku and checklist
    getCheckList();
  }

  String _sku = '';
  String get sku => _sku;
  set setSku(String str) {
    _sku = str;
  }

  String? _vehicleModel = '';
  String? get vehicleModel => _vehicleModel;

  // Check list that displays the list of activities that need to be checked by the user
  List<MCheckSheet> _checkList = [];
  List<MCheckSheet> get checkList => _checkList;

  // Current active to check
  MCheckSheet? _toCheck;
  MCheckSheet? get toCheck => _toCheck;

  // Boolean to let the user know that the inspection is complete
  bool? isComplete;

  bool _isRecordingVoice = false;
  bool get isRecordingVoice => _isRecordingVoice;

  // Current index of the element in the checklist that is being inspected
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // Function to fetch the checklist
  Future getCheckList() async {
    List list = await fetchSku(vin);
    _sku = list.first;
    _vehicleModel = list.last;

    if (_sku.isNotEmpty) {
      _checkList = await getCheckSheetList(sku);
    }

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
      (result) async {
        print(result);
        if (result.contains('verified')) {
          updateStatus(Keywords.passed.prompt);
        }
        if (result.contains('rejected')) {
          updateStatus(Keywords.failed.prompt);
        }

        if (result.contains('rec off') && _isRecordingVoice) {
          _isRecordingVoice = false;
          await super.toggleRecording();

          _checkList[_currentIndex].details?[_checkDetailsIndex].recordedPath =
              super.finalPath;
          await moveToNextOrEnd();
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

    // Once the inspection has been completed, update the result
    if (isComplete == true) await completeInspection();

    notifyListeners();
    return;
  }

  // This function is used to update the status of the current checklist
  Future updateStatus(String status) async {
    // When an inspection has been rejected then use this function
    // This is because the user needs to go through each sub detail
    // and mark the apppropriate one as rejected
    if (_toCheckDetails != null) {
      _toCheck?.details?[_checkDetailsIndex].status = status;
      _toCheckDetails?.status = status;
      if (status == Keywords.failed.prompt) {
        recordReason();
        return;
      }
      // When an inspection has been verified then use this
      // This is because the main object should be updated
    } else {
      // Update the status
      _toCheck?.status = status;
      checkList[_currentIndex].status = status;
    }

    // If the inspection has failed then the user needs to record a short description
    // that explains why the inspection has failed
    // At this point, pause the speech recogintion part and allow the user to record
    // the details

    if (_toCheckDetails != null || status == Keywords.failed.prompt) {
      evaluateSubDetails();
    } else {
      moveToNextOrEnd();
    }
  }

  moveToNextOrEnd() async {
    // Once the user has reached the end of the inspection of the sub details
    // Reset the attributes for checking the details
    if (_toCheckDetails == _toCheck?.details?.last) {
      _toCheckDetails = null;
      _checkDetailsIndex = -1;
    }

    if (_toCheckDetails != null) {
      evaluateSubDetails();
    } else {
      // Check if it is the last item in the list or not
      // If not then move to the next list
      bool isLast = checkList.length - 1 == _currentIndex;
      if (isLast == false) {
        _currentIndex = _currentIndex + 1;
        _toCheck = checkList[_currentIndex];
        isComplete = false;
      } else {
        _toCheck = null;
        _currentIndex = 0;
        isComplete = true;
      }

      await setupToCheck();
    }
  }

  Future recordReason() async {
    // Prompt the user to wait for the beep
    await super.narrateText('Record reason for rejection');

    // The below logic is required because the text to speech "speak" method
    // does not properly wait for the future. Hence if we do not use the below handler
    // the [toggleRecording] function is executed earlier and also records the text
    // In addition, since this handler is a listener it listens to all scenarios where
    // flutterTts is used
    super.flutterTts?.setCompletionHandler(() async {
      if (_toCheckDetails?.status == Keywords.failed.prompt) {
        _isRecordingVoice = true;
        notifyListeners();
        await super.toggleRecording();
      }
    });
  }

  // When a group has been rejected then the user needs to go through each sub detail
  // and state which is the one that has failed
  // Post confirming the failure, the user needs to record a short description of the reason for rejection
  CheckSheetDetails? _toCheckDetails;
  int _checkDetailsIndex = -1;
  int get checkDetailsIndex => _checkDetailsIndex;

  evaluateSubDetails() async {
    // If not proceed with the inspection
    if (_toCheckDetails == _toCheck?.details?.last) {
      moveToNextOrEnd();
    } else {
      // Increase the index by 1
      // The default value is set at -1. Hence, it always starts with 0 over here
      _checkDetailsIndex = _checkDetailsIndex + 1;

      // Assign the object from the list
      _toCheckDetails = _toCheck?.details?[_checkDetailsIndex];

      // Narrate the selected subdetail
      await super.narrateText(
        _toCheckDetails?.gROUPDET ?? 'Something went wrong',
      );
    }

    notifyListeners();
  }

  // This method is called once the inspection has been completed by the user
  // It is called automatically once the last entry has been successfully updated
  Future completeInspection() async {
    // Create the model for update
    List<Map<String, dynamic>> list = [];

    for (var e in _checkList) {
      for (var f in e.details!) {
        Map<String, dynamic> map = {
          'VIN': _vin,
          'MODEL': '',
          'SKU': _sku,
          'GROUPID': e.gROUPID,
          'GROUP_DET_ID': f.gROUPDETID,
          'RESULT': e.status ?? f.status,
          'ISSUE_DESC': '',
          'RESOLVED': null,
          'RESOUTION_DESC': null,
          'EMP_ID': super.supa.auth.currentUser?.id,
          'DT_TM': DateTime.now().toIso8601String(),
        };
        list.add(map);
      }
    }
    await super.updateInspectedCheckSheet(list);

    return;
  }

  Future<void> resetForNewInspection() async {
    _vin = '';
    _sku = '';
    _vehicleModel = null;
    _checkList = [];
    _toCheck = null;
    _isRecordingVoice = false;
    _currentIndex = 0;
    _toCheckDetails = null;
    _checkDetailsIndex = -1;
    isComplete = null;
    notifyListeners();
    return;
  }

  disposeServices() async => await super.disposeSST();
}
