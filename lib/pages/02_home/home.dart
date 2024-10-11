import 'package:flutter/material.dart';
import 'package:voice_poc/pages/02_home/s_home.dart';
import 'package:voice_poc/services/auth/auth_service.dart';
import 'package:voice_poc/services/routes/c_routes.dart';
import 'package:voice_poc/widgets/labels/w_label.dart';
import 'package:voice_poc/widgets/pages/home/w_display_inspection_types.dart';

// This is the main page that a person sees when he logs in
// The home page should primarily have an option for the person to scan a QR code and get the VIN number
// Once the person gets the VIN number an API call is made to the server to fetch the checklist
class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final service = HomeServices();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setup());
    super.initState();
  }

  setup() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () async {
            await AuthService().logOut();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.login.path,
                (route) => false,
              );
            }
          },
          child: Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Speech Demo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            WDLabel(label: 'Select type of inspection : '),
            const Divider(),
            InspectionTypeCard(heading: 'Primary Inspection', onclick: () {}),
            InspectionTypeCard(heading: 'Secondary Inspection', onclick: () {}),
            InspectionTypeCard(
              heading: 'Pre-Delivery Inspection',
              onclick: () => Navigator.pushNamed(
                context,
                Routes.preDeliveryInspection.path,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
