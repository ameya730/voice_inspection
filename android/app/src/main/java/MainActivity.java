package com.example.voice_poc_other;

import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.media.AudioManager;
import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.media.audiofx.NoiseSuppressor;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "audio_channel";
    private NoiseSuppressor noiseSuppressor;
    private AudioRecord audioRecord;

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
                    
                    // Set up noise suppression for the Bluetooth mic
                    setupNoiseSuppression();
                } else {
                    Log.d("BluetoothSCO", "Bluetooth SCO failed to activate.");
                }
            }, 3000);  // 3-second delay
        }
    }

    // Method to set up noise suppression using AudioRecord
    private void setupNoiseSuppression() {
        int bufferSize = AudioRecord.getMinBufferSize(
            44100,  // Sample rate (44.1 kHz)
            AudioFormat.CHANNEL_IN_MONO,  // Mono channel
            AudioFormat.ENCODING_PCM_16BIT  // 16-bit PCM encoding
        );

        // Initialize AudioRecord with MIC as the audio source
        audioRecord = new AudioRecord(
            MediaRecorder.AudioSource.MIC,  // Use the MIC (Bluetooth mic in this case)
            44100,  // Sample rate
            AudioFormat.CHANNEL_IN_MONO,  // Mono channel
            AudioFormat.ENCODING_PCM_16BIT,  // 16-bit PCM encoding
            bufferSize  // Buffer size
        );

        // Start recording to get an audio session ID
        audioRecord.startRecording();
        int audioSessionId = audioRecord.getAudioSessionId();  // Get the active audio session ID

        // Check if NoiseSuppressor is available and apply it to the audio session
        if (NoiseSuppressor.isAvailable()) {
            noiseSuppressor = NoiseSuppressor.create(audioSessionId);
            Log.d("NoiseSuppressor", "Noise suppression applied.");
        } else {
            Log.d("NoiseSuppressor", "Noise suppression not available on this device.");
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (noiseSuppressor != null) {
            noiseSuppressor.release();  // Clean up the NoiseSuppressor when the activity is destroyed
        }
        if (audioRecord != null) {
            audioRecord.release();  // Release AudioRecord resources
        }
    }
}
