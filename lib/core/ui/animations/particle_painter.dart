import 'dart:math';
import 'package:flutter/material.dart';
import 'particle.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final double opacity = max(0, particle.lifetime);
      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..strokeWidth = particle.size
        ..strokeCap = StrokeCap.round;

      final Offset direction =
          particle.velocity.normalized() * particle.size * 5;
      final Offset start = particle.position - direction / 2;
      final Offset end = particle.position + direction / 2;

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

extension on Offset {
  Offset normalized() {
    final double length = sqrt(dx * dx + dy * dy);
    return length > 0 ? this / length : this;
  }
}
