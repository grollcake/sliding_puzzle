import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sliding_puzzle/utils/utils.dart';

class ImagePreview extends StatefulWidget {
  final String imagePath;

  const ImagePreview({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  bool isShrink = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget;
    if (widget.imagePath.startsWith('assets/')) {
      imageWidget = Image.asset(getPreviewImagePath(widget.imagePath), fit: BoxFit.fill);
    } else {
      imageWidget = Image.file(File(widget.imagePath), fit: BoxFit.cover);
    }

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return GestureDetector(
            onLongPress: () {
              debugPrint('onLongPress');
              setState(() => isShrink = !isShrink);
            },
            child: Center(
              child: AnimatedSize(
                duration: Duration(seconds: 5),
                child: Container(
                  width: isShrink ? 100 : 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(constraints.maxWidth * .1),
                    child: imageWidget,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
