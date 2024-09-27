import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voice_poc/services/data/c_apis.dart';

mixin DataServices {
  final supa = Supabase.instance.client;

  // Basic function for all crud operations
  Future crud(APIs api, List params) async {
    try {
      switch (api) {
        case APIs.login:
          return await supa.auth.signInWithPassword(
            email: params[0],
            password: params[1],
          );
        case APIs.logout:
          return await supa.auth.signOut();

        case APIs.getCheckSheetList:
          return await supa
              .from('CHECKSHEETMAST')
              .select('*')
              .filter('SKU', 'eq', params[0]);

        default:
          return false;
      }
    } catch (e) {
      return e;
    }
  }

  // This function takes in a list of Map<String,dynamic> and returns a list of dart objects
  // This function always returns a list either empty or populated
  List<T> parseLists<T>(
      List<Map<String, dynamic>> list,
      T Function(
        Map<String, dynamic>,
      ) fromJson) {
    List<T> objects = [];
    try {
      for (Map<String, dynamic> map in list) {
        objects.add(fromJson(map));
      }

      return objects;
    } catch (e) {
      return <T>[];
    }
  }
}
