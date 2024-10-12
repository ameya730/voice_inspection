import 'dart:convert';
import 'dart:developer';

import 'package:voice_poc/features/checksheets/models/m_check_sheet.dart';
import 'package:voice_poc/services/data/c_apis.dart';
import 'package:voice_poc/services/data/s_data.dart';

class CheckSheetService with DataServices {
  Future getCheckSheetList(String sku) async {
    var result = await crud(APIs.getCheckSheetList, [sku]);
    log(jsonEncode(result));
    return parseLists<MCheckSheet>(
      result,
      MCheckSheet.fromJson,
    );
  }
}
