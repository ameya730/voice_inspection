import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:voice_poc/pages/00_landing/landing.dart';
import 'package:voice_poc/services/routes/f_routes.dart';
import 'package:voice_poc/services/themes/constants/base_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: baseTheme,
      home: const PageLanding(),
      onGenerateRoute: (settings) => PageTransition(
        child: returnRoute(settings.name ?? ''),
        settings: RouteSettings(arguments: settings.arguments),
        type: PageTransitionType.fade,
      ),
    );
  }
}
