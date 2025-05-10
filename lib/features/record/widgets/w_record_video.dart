import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class RecordVideo extends StatefulWidget {
  const RecordVideo({super.key});

  @override
  State<RecordVideo> createState() => _RecordVideoState();
}

class _RecordVideoState extends State<RecordVideo> {
  
  CameraController? controller;

  recordVideo() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );
    await controller?.initialize();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    
    if (controller == null) {
      return IconButton(
        onPressed: recordVideo,
        icon: const Icon(Icons.video_call, size: 42),
      );
    }

    return AspectRatio(aspectRatio: 16/9,child: CameraPreview(controller!)  ,);
   
  }
}