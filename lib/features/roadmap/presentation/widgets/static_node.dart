import 'package:flutter/material.dart';

class StaticNode extends StatelessWidget {
  final double size;
  final Color color;
  final Widget child;
  final double opacity;
  const StaticNode({
    super.key,
    required this.size,
    required this.color,
    required this.child,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: opacity == 1.0
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(child: child),
      ),
    );
  }
}
