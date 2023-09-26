// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class BouncingWidget extends StatefulWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final Duration duration;
  const BouncingWidget(
      {super.key, required this.child, this.onTap, required this.duration});

  @override
  _BouncingWidgetState createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<BouncingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create a bounce animation controller
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Create a bounce animation using Tween
    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reset the animation to the original position
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startBounceAnimation() {
    _controller.reset();
    _controller.forward();
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startBounceAnimation,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: Offset(0, -_animation.value), // Bounce vertically
            child: widget.child,
          );
        },
      ),
    );
  }
}
