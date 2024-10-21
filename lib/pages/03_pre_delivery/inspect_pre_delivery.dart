import 'package:barcode_newland_flutter/newland_scanner.dart';
import 'package:flutter/material.dart';
import 'package:voice_poc/features/checksheets/widgets/w_display_card.dart';
import 'package:voice_poc/pages/03_pre_delivery/s_pre_delivery.dart';
import 'package:voice_poc/services/routes/c_routes.dart';
import 'package:voice_poc/widgets/buttons/button_with_loader.dart';
import 'package:voice_poc/widgets/labels/w_label.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PageInspectPreDelivery extends StatefulWidget {
  const PageInspectPreDelivery({super.key});

  @override
  State<PageInspectPreDelivery> createState() => _PageInspectPreDeliveryState();
}

class _PageInspectPreDeliveryState extends State<PageInspectPreDelivery> {
  final services = PreDeliveryServices();

  setScanValFn(String? val) => services.setSku = val ?? '-';

  @override
  void initState() {
    WakelockPlus.enable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Newlandscanner.listenForBarcodes.listen((event) {
        services.resetForNewInspection();
        services.setVin = event.barcodeData;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        title: WDLabel(label: 'Final Inspection'),
      ),
      persistentFooterButtons: [
        ListenableBuilder(
          listenable: services,
          builder: (context, child) =>
              services.isComplete == true || services.sku.isEmpty
                  ? const SizedBox(
                      height: 0,
                      width: 0,
                    )
                  : WDButtonWithLoad(
                      label: 'Start Inspection',
                      callback: () => services.initInspection(),
                      isDisabled: services.toCheck != null ? true : false,
                    ),
        ),
      ],
      body: ListenableBuilder(
        listenable: services,
        builder: (context, child) => services.sku.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/scan.png'),
                  WDLabel(label: 'Scan to begin inspection'),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WDLabel(
                      label:
                          'Inspection of ${services.sku} for vehicle : ${services.vehicleModel} [${services.vin}]',
                    ),
                    const Divider(),
                    if (services.isComplete == true) ...[
                      WDLabel(
                        label:
                            'You have completed the inspection of the vehicle. Scan a barcode to commence inspection of next vehicle',
                      ),
                      const Divider(),
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
