import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multiple_image_camera/camera_file.dart';
import 'package:multiple_image_camera/multiple_image_camera.dart';
import 'package:voice_poc_other/features/image_capture/widgets/mutli_image_capture.dart';
import 'package:voice_poc_other/features/image_capture/widgets/single_image_capture.dart';
import 'package:voice_poc_other/pages/02_home/s_home.dart';
import 'package:voice_poc_other/services/auth/auth_service.dart';
import 'package:voice_poc_other/services/routes/c_routes.dart';
import 'package:voice_poc_other/widgets/labels/w_label.dart';
import 'package:voice_poc_other/widgets/pages/home/w_display_inspection_types.dart';

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
  List<MediaModel> images = [];

  navigateToInspection(int? i) => Navigator.pushNamed(
        context,
        Routes.preDeliveryInspection.path,
        arguments: i,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Inspection',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            WDLabel(label: 'Select type of inspection : '),
            const Divider(),
            InspectionTypeCard(
              index: 1,
              heading: 'Station 1',
              onclick: () => navigateToInspection(1),
            ),
            InspectionTypeCard(
              index: 2,
              heading: 'Station 2',
              onclick: () => navigateToInspection(2),
            ),
            InspectionTypeCard(
              index: 3,
              heading: 'Station 3',
              onclick: () => navigateToInspection(3),
            ),
            InspectionTypeCard(
              index: 4,
              heading: 'Final Inspection',
              onclick: () => navigateToInspection(null),
            ),
            SingleImageCapture(
              onCapture: (e) {
                print(e);
              },
            ),
          ],
        ),
      ),
    );
  }
}
