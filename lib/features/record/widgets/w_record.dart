import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:voice_poc/features/record/services/s_record.dart';

class WDRecord extends StatefulWidget {
  const WDRecord({super.key});

  @override
  State<WDRecord> createState() => _WDRecordState();
}

class _WDRecordState extends State<WDRecord> {
  final service = RecordServices();
  final audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: service,
      builder: (context, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async => await service.toggleRecording(),
              child: Icon(
                service.isRecording ? Icons.mic_off : Icons.mic,
                size: 42,
              ),
            ),
            InkWell(
              onTap: () async => await audioPlayer.play(
                DeviceFileSource(service.finalPath, mimeType: 'wav'),
              ),
              child: Icon(
                Icons.play_arrow,
                size: 42,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
