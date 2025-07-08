import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SpriteAnimationWidget extends StatefulWidget {
  final ImageProvider image;
  final int frameCount;
  final int framesPerRow;
  final double frameWidth;
  final double frameHeight;
  final Duration frameDuration;
  final double scale;

  const SpriteAnimationWidget({
    super.key,
    required this.image,
    required this.frameCount,
    required this.framesPerRow,
    required this.frameWidth,
    required this.frameHeight,
    this.frameDuration = const Duration(milliseconds: 80),
    this.scale = 1.0,
  });

  @override
  State<SpriteAnimationWidget> createState() => _SpriteAnimationWidgetState();
}

class _SpriteAnimationWidgetState extends State<SpriteAnimationWidget> {
  late Timer _timer;
  int _currentFrame = 0;
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.frameDuration, (_) {
      setState(() {
        _currentFrame = (_currentFrame + 1) % widget.frameCount;
      });
    });
    _resolveImage();
  }

  void _resolveImage() {
    _imageStream = widget.image.resolve(const ImageConfiguration());
    _imageStream!.addListener(ImageStreamListener((info, _) {
      setState(() {
        _imageInfo = info;
      });
    }));
  }

  @override
  void didUpdateWidget(covariant SpriteAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      _resolveImage();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageInfo == null) {
      return const SizedBox.shrink();
    }
    final row = _currentFrame ~/ widget.framesPerRow;
    final col = _currentFrame % widget.framesPerRow;
    final src = Rect.fromLTWH(
      col * widget.frameWidth,
      row * widget.frameHeight,
      widget.frameWidth,
      widget.frameHeight,
    );
    final dst = Rect.fromLTWH(
      0,
      0,
      widget.frameWidth * widget.scale,
      widget.frameHeight * widget.scale,
    );
    return CustomPaint(
      size: Size(
          widget.frameWidth * widget.scale, widget.frameHeight * widget.scale),
      painter: _SpritePainter(_imageInfo!.image, src, dst),
    );
  }
}

class _SpritePainter extends CustomPainter {
  final ui.Image image;
  final Rect src;
  final Rect dst;

  _SpritePainter(this.image, this.src, this.dst);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(image, src, dst, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
