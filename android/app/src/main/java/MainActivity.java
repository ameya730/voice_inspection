package com.example.voice_poc;

import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.media.AudioManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;  // Import Looper for the main thread
import android.util.Log;  // For logging
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "audio_channel";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                if (call.method.equals("switchToBluetoothMic")) {
                    switchToBluetoothMic();
                    result.success(null);
                } else {
                    result.notImplemented();
                }
            });
    }

    private void switchToBluetoothMic() {
        AudioManager audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        if (bluetoothAdapter != null && bluetoothAdapter.isEnabled()) {
            audioManager.startBluetoothSco();
            audioManager.setBluetoothScoOn(true);

            // Add a delay to give time for SCO to start
            new Handler(Looper.getMainLooper()).postDelayed(() -> {
                if (audioManager.isBluetoothScoOn()) {
                    Log.d("BluetoothSCO", "Bluetooth SCO is active.");
                } else {
                    Log.d("BluetoothSCO", "Bluetooth SCO failed to activate.");
                }
            }, 3000);  // 3-second delay
        }
    }
}
