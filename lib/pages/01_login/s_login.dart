import 'package:flutter/material.dart';
import 'package:voice_poc/services/auth/auth_service.dart';
import 'package:voice_poc/services/routes/c_routes.dart';

class LoginService extends AuthService {
  String _email = '';
  set setEmail(String str) => _email = str;
  String _password = '';
  set setPassword(String str) => _password = str;

  Future loginFn(BuildContext context) async {
    var response = await login(_email, _password);
    if (response[0] && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.home.path,
        (route) => false,
      );
    }
    return;
  }
}
