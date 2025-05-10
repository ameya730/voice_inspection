import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class WDRecord extends StatefulWidget {
  const WDRecord({super.key, required this.toggleRecording});
  final Function(bool isPlaying) toggleRecording;

  @override
  State<WDRecord> createState() => _WDRecordState();
}

class _WDRecordState extends State<WDRecord> {
  bool isPlaying = false;
  final audioPlayer = AudioPlayer();

  toggleRecordingFn() {
    isPlaying = !isPlaying;

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: toggleRecordingFn,
            child: Icon(
              isPlaying ? Icons.mic_off : Icons.mic,
              size: 42,
            ),
          ),
          // InkWell(
          //   onTap: () async => await audioPlayer.play(
          //     DeviceFileSource(service.finalPath, mimeType: 'wav'),
          //   ),
          //   child: Icon(
          //     Icons.play_arrow,
          //     size: 42,
          //   ),
          // ),
        ],
      ),
    );
  }
}
