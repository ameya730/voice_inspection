import 'package:supabase_flutter/supabase_flutter.dart';

mixin VinMixin {
  final supa = Supabase.instance.client;

  // This method is use to update the VIN in the SKU master database
  // At the present moment the SKU reference has been hard coded in the function
  // but in the future an alternative would need to be identified for it
  Future insertVinInDb(String vin) async {
    List<Map<String, dynamic>> res =
        await supa.from('VINSKUMAST').select("*").eq('VIN', vin);
    if (res.isNotEmpty) return;

    await supa.from('VINSKUMAST').insert([
      {'VIN': vin, 'SKU': '00JU0AZZ'}
    ]).select();

    return;
  }

  // Fetch the SKU number for this the selected VIN
  // In the future this would be replaced as well
  Future<List> fetchSku(String vin) async {
    try {
      List<Map<String, dynamic>> result =
          await supa.from('VINSKUMAST').select('SKU').eq('VIN', vin);

      List<Map<String, dynamic>> response =
          await supa.from('VEHICLESKUMAST').select('Model').eq(
                'SKU',
                result.first['SKU'],
              );
      return [result.first['SKU'], response.first['Model']];
    } catch (e) {
      return [];
    }
  }

  // The below method checks if a VIN has already been inspected or not
  // It should return a bool with true being ok to inspect and false being already inspected
  Future<bool> isVinOkToInspect(String vin, int? station) async {
    print('The values are ${{"vin_value": vin, "station_value": station}}');
    try {
      var res = await supa.rpc(
        'check_if_inspection_is_pending',
        params: {"vin_value": vin, "station_value": station},
      );
      print('The response is $res');
      if (res.first['exist'] == 'inspection_completed') return false;
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }
}
