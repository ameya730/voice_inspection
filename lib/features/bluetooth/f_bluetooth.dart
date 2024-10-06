import 'dart:developer';

import 'package:flutter/services.dart';

class AudioService {
  static const platform = MethodChannel('audio_channel');

  Future<void> switchToBluetoothMic() async {
    try {
      await platform.invokeMethod('switchToBluetoothMic');
    } on PlatformException catch (e) {
      log("Failed to switch to Bluetooth mic: '${e.message}'.");
    }
  }
}
