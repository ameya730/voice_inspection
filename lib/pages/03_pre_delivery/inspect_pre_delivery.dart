import 'package:flutter/material.dart';
import 'package:voice_poc/features/checksheets/widgets/w_display_card.dart';
import 'package:voice_poc/features/scanner/widgets/w_scan_qr.dart';
import 'package:voice_poc/pages/03_pre_delivery/s_pre_delivery.dart';
import 'package:voice_poc/services/routes/c_routes.dart';
import 'package:voice_poc/widgets/buttons/button_with_loader.dart';
import 'package:voice_poc/widgets/labels/w_label.dart';

class PageInspectPreDelivery extends StatefulWidget {
  const PageInspectPreDelivery({super.key});

  @override
  State<PageInspectPreDelivery> createState() => _PageInspectPreDeliveryState();
}

class _PageInspectPreDeliveryState extends State<PageInspectPreDelivery> {
  final services = PreDeliveryServices();

  setScanValFn(String? val) => services.setSku = val ?? '-';

  @override
  void dispose() {
    services.disposeServices();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WDLabel(label: 'Pre-Delivery Inspection'),
      ),
      persistentFooterButtons: [
        ListenableBuilder(
          listenable: services,
          builder: (context, child) => services.isComplete == true
              ? const SizedBox(
                  height: 0,
                  width: 0,
                )
              : WDButtonWithLoad(
                  label: 'Start Inspection',
                  callback: () => services.initInspection(),
                ),
        ),
      ],
      body: ListenableBuilder(
        listenable: services,
        builder: (context, child) => services.sku.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: WDScanQR(
                  returnValue: (scannedVal) => setScanValFn(scannedVal),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WDLabel(label: 'Inspection of ${services.sku}'),
                    const Divider(),
                    if (services.isComplete == true) ...[
                      WDLabel(
                          label:
                              'You have completed the inspection of the vehicle.'),
                      WDButtonWithLoad(
                        label: 'Start another inspection',
                        callback: () {},
                      ),
                      WDLabel(label: '--Or--'),
                      WDButtonWithLoad(
                        label: 'Return to home page',
                        callback: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.home.path,
                          (route) => false,
                        ),
                      ),
                    ],
                    Expanded(
                      child: ListView(
                        children: services.checkList
                            .map(
                              (e) => WDDisplayCheckListCard(
                                model: e,
                                service: services,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
