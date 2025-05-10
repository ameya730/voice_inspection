import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

mixin RecordServices {
  final AudioRecorder _recorder = AudioRecorder();
  String _tempPath = '';
  String _finalPath = '';
  String get finalPath => _finalPath;
  set setTempPath(String str) => _tempPath = str;
  set setFinalPath(String str) => _finalPath = str;

  Future toggleRecording() async {
    _tempPath = (await getTemporaryDirectory()).path;

    // If the recording is currently ongoing, stop it
    if (await _recorder.isRecording()) {
      _finalPath = await _recorder.stop() ?? '';
      return _finalPath;
    }

    // Start the recording
    else {
      final name = DateFormat('ddmmyyhhmmss').format(DateTime.now());
      _tempPath = (await getTemporaryDirectory()).path;      
      await _recorder.start(        
        const RecordConfig(
          encoder: AudioEncoder.wav,
          echoCancel: true,
          noiseSuppress: true,
          bitRate: 128000,
          sampleRate: 44100,
          numChannels: 2,
        ),        
        path: '$_tempPath${'/'}$name',
      );
    }
  }

  void disposeService() => _recorder.dispose();
}
