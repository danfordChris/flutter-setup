import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:solomon/core/resources/resources.dart';

class LoadingAnimation extends StatefulWidget {
  final double width;
  final double height;
  final double gap;
  final Duration duration;

  const LoadingAnimation({super.key, this.width = 40, this.height = 40, this.gap = -10, this.duration = const Duration(milliseconds: 2200)});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  ui.Image? _redImage;
  ui.Image? _blueImage;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();

    _loadImages();
  }

  Future<void> _loadImages() async {
    final red = await _loadImage(Images.logoRedPiece);
    final blue = await _loadImage(Images.logoBluePiece);
    setState(() {
      _redImage = red;
      _blueImage = blue;
      _isLoaded = true;
    });
  }

  Future<ui.Image> _loadImage(String assetPath) async {
    final data = await DefaultAssetBundle.of(context).load(assetPath);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const SizedBox(); // or loading indicator
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _PieceSwapPainter(
            progress: _controller.value,
            redImage: _redImage!,
            blueImage: _blueImage!,
            width: widget.width,
            height: widget.height,
            gap: widget.gap,
          ),
          size: Size(widget.width * 3, widget.height * 2.5),
        );
      },
    );
  }
}

class _PieceSwapPainter extends CustomPainter {
  final double progress;
  final ui.Image redImage;
  final ui.Image blueImage;
  final double width;
  final double height;
  final double gap;

  _PieceSwapPainter({
    required this.progress,
    required this.redImage,
    required this.blueImage,
    required this.width,
    required this.height,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    final double halfW = width / 2;
    final double halfH = height / 2;
    final double halfGap = gap / 2;
    final double verticalShift = halfH;
    final double horizontalShift = width + halfGap;
    final double initialOffset = halfW + halfGap;

    Offset redCenter = Offset(cx - initialOffset, cy);
    Offset blueCenter = Offset(cx + initialOffset, cy);

    final double t = (progress * 4) % 4;
    final double localT = t % 1;

    if (t < 1) {
      redCenter = redCenter.translate(0, -verticalShift * localT);
      blueCenter = blueCenter.translate(0, verticalShift * localT);
    } else if (t < 2) {
      redCenter = redCenter.translate(0, -verticalShift).translate(horizontalShift * localT, 0);
      blueCenter = blueCenter.translate(0, verticalShift).translate(-horizontalShift * localT, 0);
    } else if (t < 3) {
      redCenter = redCenter.translate(horizontalShift, -verticalShift + verticalShift * localT);
      blueCenter = blueCenter.translate(-horizontalShift, verticalShift - verticalShift * localT);
    } else {
      redCenter = redCenter.translate(horizontalShift - horizontalShift * localT, 0);
      blueCenter = blueCenter.translate(-horizontalShift + horizontalShift * localT, 0);
    }

    _drawImage(canvas, redImage, redCenter, width, height);
    _drawImage(canvas, blueImage, blueCenter, width, height);
  }

  void _drawImage(Canvas canvas, ui.Image image, Offset center, double w, double h) {
    final Rect dst = Rect.fromCenter(center: center, width: w, height: h);
    paintImage(canvas: canvas, rect: dst, image: image, fit: BoxFit.contain, filterQuality: FilterQuality.high);
  }

  @override
  bool shouldRepaint(_PieceSwapPainter old) =>
      old.progress != progress ||
      old.width != width ||
      old.height != height ||
      old.gap != gap ||
      old.redImage != redImage ||
      old.blueImage != blueImage;
}
