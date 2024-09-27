import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voice_poc/env/env.dart';
import 'package:voice_poc/services/links/links.dart';

class LandingService {
  initFn() async {
    await Future.wait(
      [
        Supabase.initialize(
          url: Links.devLink.path,
          anonKey: Env.anonkey,
        ),
      ],
    );
    return;
  }
}
