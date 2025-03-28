import 'dart:math';

import 'package:cosmo_clicker/core/ui/animations/particle.dart';
import 'package:cosmo_clicker/core/ui/animations/particle_painter.dart';
import 'package:flutter/material.dart';

class ParticleExplosion extends StatefulWidget {
  final Offset? tapPosition;
  const ParticleExplosion({super.key, this.tapPosition});

  @override
  State<ParticleExplosion> createState() => _ParticleExplositonState();
}

class _ParticleExplositonState extends State<ParticleExplosion>
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
  void didUpdateWidget(covariant ParticleExplosion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tapPosition != null) {
      _generateParticles(widget.tapPosition!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateParticles(Offset tapPosition) {
    final random = Random();
    List<Particle> newParticles = List.generate(60, (_) {
      final direction = random.nextDouble() * 2 * pi;
      final speed = random.nextDouble() * 2 + 1;

      return Particle(
        position: tapPosition,
        velocity: Offset(cos(direction) * speed, sin(direction) * speed),
        color: Colors.white70,
        size: 2,
        lifetime: 0.7,
      );
    });

    _particles.addAll(newParticles);
    _controller.reset();
    _controller.forward();
  }

  void _updateParticles() {
    const Offset gravity = Offset(0, 0.1);

    for (final particle in _particles) {
      particle.velocity += gravity;
      particle.position += particle.velocity;
      particle.lifetime -= 0.02;
    }
    _particles.removeWhere((particle) => particle.lifetime <= 0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: ParticlePainter(_particles),
      ),
    );
  }
}
