import 'package:cosmo_clicker/core/ui/animations/particle.dart';
import 'package:flutter/material.dart';

class ParticlePainter extends CustomPainter{
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {

    for(final particle in particles) {
      final paint = Paint()..color = particle.color;
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}