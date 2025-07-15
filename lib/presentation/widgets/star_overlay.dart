import 'dart:math';
import 'package:flutter/material.dart';

class StarOverlay extends StatelessWidget {
  final int starCount;
  final double width;
  final double height;
  final Offset? moonCenter;
  final double moonRadius;

  const StarOverlay({
    super.key,
    required this.starCount,
    required this.width,
    required this.height,
    this.moonCenter,
    this.moonRadius = 120,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random(starCount);
    final List<Widget> stars = [];
    int attempts = 0;
    int placed = 0;

    while (placed < starCount && attempts < starCount * 10) {
      final left = random.nextDouble() * (width - 40);
      final top = random.nextDouble() * (height - 40);
      final starCenter = Offset(left + 16, top + 16);

      bool overlapsMoon = false;
      if (moonCenter != null) {
        overlapsMoon =
            (starCenter - moonCenter!).distance < moonRadius / 2 + 24;
      }

      if (!overlapsMoon) {
        stars.add(Positioned(
          left: left,
          top: top,
          child: CustomPaint(
            size: const Size(32, 32),
            painter: _StarPainter(),
          ),
        ));
        placed++;
      }
      attempts++;
    }

    return Stack(children: stars);
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final points = <Offset>[];
    const spikes = 8;
    final random = Random(42);
    for (int i = 0; i < spikes; i++) {
      final angle = (2 * pi / spikes) * i;
      final len = (i.isEven ? 1.0 : 0.7) * (0.45 + random.nextDouble() * 0.08);
      final dx = cos(angle) * size.width * len;
      final dy = sin(angle) * size.height * len;
      points.add(center + Offset(dx, dy));
    }
    for (final p in points) {
      canvas.drawLine(center, p, paint);
    }

    final diagPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    for (int i = 0; i < spikes; i++) {
      final angle = (2 * pi / spikes) * i + pi / spikes;
      final len = (i.isEven ? 0.5 : 0.35) * (0.45 + random.nextDouble() * 0.08);
      final dx = cos(angle) * size.width * len;
      final dy = sin(angle) * size.height * len;
      canvas.drawLine(center, center + Offset(dx, dy), diagPaint);
    }

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(center, size.width * 0.09, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
