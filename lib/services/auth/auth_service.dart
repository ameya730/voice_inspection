import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voice_poc/services/data/c_apis.dart';
import 'package:voice_poc/services/data/s_data.dart';

class AuthService with DataServices {
  Future login(String email, String password) async {
    var res = await crud(APIs.login, [email, password]);
    if (res.runtimeType == AuthResponse) {
      return [true, ''];
    } else if (res.runtimeType == AuthApiException) {
      AuthApiException err = res as AuthApiException;
      return [false, err.message];
    } else {
      return [false, 'Something went wrong'];
    }
  }

  Future logOut() async => await crud(APIs.logout, []);
}
