import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:voice_poc_other/features/record/services/s_record.dart';

class WDRecord extends StatefulWidget {
  const WDRecord({super.key, required this.updateMediaPath, this.mediaPath, this.onStartRecording, this.onStopRecording,});
  final Function(String path) updateMediaPath;
  final String? mediaPath;
  final Function()? onStartRecording;
  final Function()? onStopRecording;

  @override
  State<WDRecord> createState() => _WDRecordState();
}

class _WDRecordState extends State<WDRecord> with RecordServices {
  bool isPlaying = false;
  final audioPlayer = AudioPlayer();
  final recorder = AudioRecorder();
  bool isRecording = false;
  String finalPath = '';

  startRecording() async {
    print('startRecording');
    bool check = await recorder.hasPermission();
    print('check: $check');
    if (!check) {
      print('Permission not granted');
      return;
    }

    if (widget.onStartRecording != null) {
      await widget.onStartRecording?.call();
    }

    String tempPath = (await getTemporaryDirectory()).path;
    final name = DateFormat('ddmmyyhhmmss').format(DateTime.now());
    finalPath = '$tempPath${'/'}$name';
    isRecording = true;
    if (mounted) setState(() {});
    await recorder.start(const RecordConfig(encoder: AudioEncoder.wav),
        path: finalPath);
  }

  stopRecording() async {
    print('stopRecording');
    await recorder.stop();
    
    widget.updateMediaPath(finalPath);    
    if (widget.onStopRecording != null) {
      await widget.onStopRecording?.call();
    }
    isRecording = false;
    if (mounted) setState(() {});
  }

  playAudio() async {
    isPlaying = !isPlaying;
    if (mounted) setState(() {});
    print('playAudio');
    print('finalPath: $finalPath');
    await audioPlayer.play(DeviceFileSource(widget.mediaPath!, mimeType: 'wav'));
    isPlaying = !isPlaying;
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant WDRecord oldWidget) {
    if (oldWidget.mediaPath != widget.mediaPath) {
      if (mounted) setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if ((widget.mediaPath??'').isNotEmpty && !isRecording) ...[
            InkWell(
              onTap: () => playAudio(),
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 42),
            ),
          ] else ...[
            InkWell(
              onTap: () => isRecording ? stopRecording() : startRecording(),
              child: Icon(
                isRecording ? Icons.mic_off : Icons.mic,
                size: 42,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
