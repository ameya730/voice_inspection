import 'package:flutter/services.dart';

class AudioService {
  static const platform = MethodChannel('audio_channel');

  Future<void> switchToBluetoothMic() async {
    try {
      var result = await platform.invokeMethod('switchToBluetoothMic');
      print('The result is $result');
    } on PlatformException catch (e) {
      print("Failed to switch to Bluetooth mic: '${e.message}'.");
    }
  }
}
