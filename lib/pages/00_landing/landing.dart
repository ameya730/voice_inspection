import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voice_poc_other/pages/00_landing/landing_service.dart';
import 'package:voice_poc_other/services/routes/c_routes.dart';

class PageLanding extends StatelessWidget {
  const PageLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LandingService().initFn(),
      builder: (context, snapshot) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Check if there is a valid user and decide the route accordingly
              final supa = Supabase.instance.client;
              String path = Routes.login.path;

              // If there is an active user session
              if (supa.auth.currentSession != null) {
                // Check if the user's session has expired or not
                bool check = supa.auth.currentSession!.isExpired;
                if (check == false) path = Routes.home.path;
              }

              // Navigate to the appropriate path
              Navigator.pushNamedAndRemoveUntil(
                context,
                path,
                (route) => false,
              );
            }
          },
        );

        return const SafeArea(
          child: Scaffold(
            body: Center(
              child: LinearProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
