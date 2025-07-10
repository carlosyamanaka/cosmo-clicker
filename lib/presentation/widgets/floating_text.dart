import 'package:flutter/material.dart';

class FloatingText extends StatefulWidget {
  final Offset position;
  final int value;
  final VoidCallback onCompleted;

  const FloatingText({
    required Key key,
    required this.position,
    required this.value,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<FloatingText> createState() => _FloatingTextState();
}

class _FloatingTextState extends State<FloatingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: -60).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: widget.position.dx - 30,
          top: widget.position.dy - 50 + _animation.value,
          child: Opacity(
            opacity: 1 - _controller.value,
            child: Text(
              '+${widget.value}',
              style: const TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 22,
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
