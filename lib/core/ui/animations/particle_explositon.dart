import 'dart:math';

import 'package:cosmo_clicker/core/ui/animations/particle.dart';
import 'package:cosmo_clicker/core/ui/animations/particle_painter.dart';
import 'package:flutter/material.dart';

class ParticleExplositon extends StatefulWidget {
  const ParticleExplositon({super.key});

  @override
  State<ParticleExplositon> createState() => _ParticleExplositonState();
}

class _ParticleExplositonState extends State<ParticleExplositon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..addListener(() {
            setState(() {
              _updateParticles();
            });
          });

    _particles = [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateParticles(Offset tapPosition) {
    final random = Random();
    _particles = List.generate(100, (_) {
      final direction = random.nextDouble() * 2 * pi;
      final speed = random.nextDouble() * 5 + 2;

      return Particle(
        position: tapPosition,
        velocity: Offset(cos(direction) * speed, sin(direction) * speed),
        color: Colors.purple,
        size: 10,
        lifetime: 1.0,
      );
    });

    _controller.reset();
    _controller.forward();
  }

  void _updateParticles() {
    for(final particle in _particles) {
      particle.position += particle.velocity;
      particle.lifetime -= 0.02;
    }
    _particles.removeWhere((particle) => particle.lifetime <= 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _generateParticles(details.localPosition);
      },
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: ParticlePainter(_particles),
      ),
    );
  }
}
