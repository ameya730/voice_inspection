import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:voice_poc/widgets/labels/w_label.dart';

class WDScanQR extends StatefulWidget {
  const WDScanQR({super.key, required this.returnValue});
  final Function(String? scannedVal) returnValue;

  @override
  State<WDScanQR> createState() => _WDScanQRState();
}

class _WDScanQRState extends State<WDScanQR> {
  MobileScannerController c = MobileScannerController();
  String? scannedVal;

  @override
  dispose() {
    c.dispose();
    super.dispose();
  }

  onDetect(BarcodeCapture capture) {
    if (scannedVal != null) return;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (mounted) setState(() {});
      widget.returnValue(barcode.rawValue);
    }
  }

  onError(BuildContext context, MobileScannerException error) {
    return WDLabel(label: error.errorDetails?.message ?? '-');
  }

  scanAgainFn() {
    scannedVal = null;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (scannedVal != null) {
      return InkWell(
        onTap: scanAgainFn,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  color: Colors.blueGrey,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const WDLabel(label: 'Tap to scan again'),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: MobileScanner(
          controller: c,
          errorBuilder: (p0, p1, p2) => onError(p0, p1),
          onDetect: (capture) => onDetect(capture),
        ),
      ),
    );
  }
}
