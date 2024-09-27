import 'package:voice_poc/pages/00_landing/landing.dart';
import 'package:voice_poc/pages/01_login/Login.dart';
import 'package:voice_poc/pages/02_home/home.dart';
import 'package:voice_poc/services/routes/c_routes.dart';

returnRoute(String route) {
  final Map<String, dynamic> map = {
    Routes.landing.path: const PageLanding(),
    Routes.login.path: const PageLogin(),
    Routes.home.path: const PageHome(),
  };
  return map[route] ?? const PageLogin();
}
