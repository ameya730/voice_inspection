import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordServices with ChangeNotifier {
  final AudioRecorder _recorder = AudioRecorder();
  String _tempPath = '';
  bool _isRecording = false;
  bool get isRecording => _isRecording;
  String _finalPath = '';
  String get finalPath => _finalPath;

  Future<void> initServices() async {
    _tempPath = (await getTemporaryDirectory()).path;
  }

  Future<void> toggleRecording() async {
    _tempPath = (await getTemporaryDirectory()).path;
    print(_tempPath);
    // If the recording is currently ongoing, stop it
    if (await _recorder.isRecording()) {
      _finalPath = await _recorder.stop() ?? '';
      print('The final path is $_finalPath');
      _isRecording = false;
    }

    // Start the recording
    else {
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: '$_tempPath/test.wav',
      );
      _isRecording = true;
      print('is it recording ${await _recorder.isRecording()}');
    }
    notifyListeners();
  }

  Future test() async {
    _tempPath = (await getTemporaryDirectory()).path;
    bool isExist = await File(finalPath).exists();
    print('$finalPath $isExist');
  }

  void disposeService() => _recorder.dispose();
}
