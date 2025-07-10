import 'dart:math';
import 'package:flutter/material.dart';
import 'particle.dart';
import 'particle_painter.dart';

class ParticleExplosion extends StatefulWidget {
  final Offset? tapPosition;
  const ParticleExplosion({super.key, this.tapPosition});

  @override
  State<ParticleExplosion> createState() => _ParticleExplosionState();
}

class _ParticleExplosionState extends State<ParticleExplosion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final int _maxParticles = 150;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..addListener(() {
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
    int particleNumberGenerate = 11;

    if (_particles.length > _maxParticles) {
      particleNumberGenerate = 5;
    }

    double generateValidDirection(Random random) {
      double direction = random.nextDouble() * 2 * pi;
      if (direction > 265 * pi / 180 && direction < 275 * pi / 180) {
        direction += pi;
      }
      return direction;
    }

    List<Particle> newParticles = List.generate(particleNumberGenerate, (_) {
      final direction = generateValidDirection(random);
      final speed = random.nextDouble() * 2 + 1;
      final gravity = Offset(0, random.nextDouble() * 0.1 * 0.2);
      final size = random.nextDouble() * 1.5 + 0.7;

      return Particle(
        position: tapPosition,
        velocity: Offset(cos(direction) * speed, sin(direction) * speed),
        gravity: gravity,
        color: Colors.white,
        size: size,
        lifetime: random.nextDouble() * 0.5 + 0.4,
      );
    });

    _particles.addAll(newParticles);
    _controller.reset();
    _controller.forward();
  }

  void _updateParticles() {
    for (final particle in _particles) {
      particle.velocity += particle.gravity;
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
