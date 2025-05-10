import 'package:voice_poc_other/features/checksheets/models/m_check_sheet.dart';
import 'package:voice_poc_other/services/data/c_apis.dart';
import 'package:voice_poc_other/services/data/s_data.dart';

class CheckSheetService with DataServices {
  // Method to fetch the checklist that the user needs to inspect
  Future getCheckSheetList(String sku) async {
    var result = await crud(APIs.getCheckSheetList, [sku]);
    return parseLists<MCheckSheet>(
      result,
      MCheckSheet.fromJson,
    );
  }

  // Method to update the checklist in the database
  // once the inspection has been completed by the user
  Future<bool> updateInspectedCheckSheet(
      List<Map<String, dynamic>> data) async {
    try {
      await super.supa.from('VEHPDIRESULT').insert(data).select();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
