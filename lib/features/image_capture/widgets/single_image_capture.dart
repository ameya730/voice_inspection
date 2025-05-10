import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SingleImageCapture extends StatefulWidget {
  const SingleImageCapture({
    super.key,
    required this.onCapture,
  });
  final Function(XFile) onCapture;

  @override
  State<SingleImageCapture> createState() => _SingleImageCaptureState();
}

class _SingleImageCaptureState extends State<SingleImageCapture> {
  XFile? image;

  Future<void> _captureImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        image = pickedFile;
        widget.onCapture(image!);
      });
    }
  }

  _deleteImage() {
    setState(() {
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return IconButton(
        onPressed: _captureImage,
        icon: const Icon(Icons.photo_camera, size: 42),
      );
    }

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Image.file(
          File(image!.path),
          width: MediaQuery.of(context).size.width * 0.27,
          height: MediaQuery.of(context).size.width * 0.27,
        ),
        IconButton(
          onPressed: _deleteImage,
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
            size: 24,
          ),
        ),
      ],
    );
  }
}
