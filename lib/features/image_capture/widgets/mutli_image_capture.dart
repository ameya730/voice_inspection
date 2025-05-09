import 'package:flutter/material.dart';
import 'package:multiple_image_camera/camera_file.dart';
import 'package:multiple_image_camera/multiple_image_camera.dart';

class MultiImageCapture extends StatefulWidget {
  const MultiImageCapture({
    super.key,
    required this.images,
    required this.onDeleteImage,
    required this.onCapture,
  });
  final List<MediaModel> images;
  final Function(MediaModel) onDeleteImage;
  final Function(List<MediaModel>) onCapture;

  @override
  State<MultiImageCapture> createState() => _MultiImageCaptureState();
}

class _MultiImageCaptureState extends State<MultiImageCapture> {
  onCapture() async {
    List<MediaModel> images = await MultipleImageCamera.capture(
      context: context,      
    );
    widget.onCapture(images);
    if (images.isNotEmpty) {
      await widget.onCapture(images);
      if (mounted) setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant MultiImageCapture oldWidget) {
    if (oldWidget.images != widget.images) {
      if (mounted) setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onCapture,
          icon: Icon(Icons.photo_camera, size: 42),
        ),
        if (widget.images.isNotEmpty) ...[
          Wrap(
            children: [
              for (var e in widget.images) ...[
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.27,
                      padding: const EdgeInsets.all(8),
                      child: Image.file(e.file),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: IconButton.filledTonal(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white),
                        ),
                        onPressed: () => widget.onDeleteImage(e),
                        icon: Icon(Icons.delete, size: 24, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
