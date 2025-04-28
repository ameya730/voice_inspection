import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voice_poc_other/env/env.dart';
import 'package:voice_poc_other/services/links/links.dart';

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
