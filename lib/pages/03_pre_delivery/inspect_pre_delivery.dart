import 'package:barcode_newland_flutter/newland_scanner.dart';
import 'package:flutter/material.dart';
import 'package:voice_poc_other/features/checksheets/widgets/w_display_card.dart';
import 'package:voice_poc_other/features/scanner/widgets/w_scan_qr.dart';
import 'package:voice_poc_other/features/text_to_speech/widgets/w_change_speech_rate.dart';
import 'package:voice_poc_other/pages/03_pre_delivery/s_pre_delivery.dart';
import 'package:voice_poc_other/widgets/buttons/button_with_loader.dart';
import 'package:voice_poc_other/widgets/labels/w_label.dart';
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
      Newlandscanner.listenForBarcodes.listen((event) async {
        await services.resetForNewInspection().then(
              (value) => onScanFn(event.barcodeData),
            );
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    services.disposeServices();
    super.dispose();
  }

  onScanFn(String barCode) async {
    await services.resetForNewInspection().then(
      (value) async {
        services.setVin = barCode;
        var res = await services.getCheckList();
        if (res == false && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: WDLabel(
                label: 'This VIN has already been inspected.',
              ),
            ),
          );
        }
      },
    );
  }

  openSettingsFn() async {
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Speech Rate'),
          actions: [
            WDChangeSpeechRate(
              val: services.getSpeechRate,
              onChanged: (p0) {
                services.setSpeechRate(p0);
                if (mounted) setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        title: WDLabel(label: 'Final Inspection'),
        actions: [
          InkWell(
            onTap: () => openSettingsFn(),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.settings,
                size: 32,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      persistentFooterButtons: [
        ListenableBuilder(
          listenable: services,
          builder: (context, child) =>
              services.isComplete == true || services.sku.isEmpty
                  ? Align(
                      alignment: Alignment.bottomLeft,
                      child: WDScanQR(
                        returnValue: (scannedVal) => onScanFn(scannedVal ?? ''),
                      ),
                    )
                  : const SizedBox(),
        ),
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
                  WDLabel(
                    label: 'Scan Machine',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WDLabel(
                      label:
                          'Inspection of ${services.sku} for machine : ${services.vehicleModel} [${services.vin}]',
                    ),
                    const Divider(),
                    if (services.isComplete == true) ...[
                      WDLabel(
                        label:
                            'You have completed the inspection of the machine. Scan a barcode to commence inspection of next machine',
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
