import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset velocity;
  Offset gravity;
  Color color;
  double size;
  double lifetime;

  Particle({
    required this.position,
    required this.velocity,
    required this.gravity,
    required this.color,
    required this.size,
    required this.lifetime,
  });
}
