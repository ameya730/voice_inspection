import 'package:supabase_flutter/supabase_flutter.dart';

mixin VinMixin {
  final supa = Supabase.instance.client;
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
}
