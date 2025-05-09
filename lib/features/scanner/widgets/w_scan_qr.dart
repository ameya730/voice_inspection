import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:voice_poc_other/widgets/labels/w_label.dart';

class WDScanQR extends StatefulWidget {
  const WDScanQR({super.key, required this.returnValue});
  final Function(String? scannedVal) returnValue;

  @override
  State<WDScanQR> createState() => _WDScanQRState();
}

class _WDScanQRState extends State<WDScanQR> {
  // MobileScannerController c = MobileScannerController();
  String? scannedVal;

  @override
  dispose() {
    // c.dispose();
    super.dispose();
  }

  onDetect(BarcodeCapture capture) {
    if (scannedVal != null) return;
    scannedVal = capture.toString();
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (mounted) setState(() {});
      widget.returnValue(barcode.rawValue);
    }
    scannedVal = null;
    if (context.mounted) Navigator.pop(context);
  }

  onError(BuildContext context, MobileScannerException error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: WDLabel(label: error.errorDetails?.message ?? '-'),
        ),
      );
    }

    return;
  }

  scanAgainFn() {
    scannedVal = null;
    if (mounted) setState(() {});
  }

  openScanner() async {
    await showDialog(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.5,
          child: MobileScanner(
            // controller: c,
            errorBuilder: (p0, p1, p2) {
              // onError(p0, p1);
              // Navigator.pop(context);
              return WDLabel(label: p1.errorDetails?.message ?? '-');
            },
            onDetect: (capture) {
              onDetect(capture);
              // Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openScanner(),
      child: SvgPicture.asset(
        'assets/icons/icon_barcode_scanner.svg',
        height: 32,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
