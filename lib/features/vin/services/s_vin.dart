import 'package:supabase_flutter/supabase_flutter.dart';

mixin VinMixin {
  final supa = Supabase.instance.client;
  Future<String> fetchSku(String vin) async {
    try {
      List<Map<String, dynamic>> result =
          await supa.from('VINSKUMAST').select('SKU').eq('VIN', vin);
      return result.first['SKU'];
    } catch (e) {
      return '';
    }
  }
}
