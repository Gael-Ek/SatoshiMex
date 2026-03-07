import 'package:flutter/material.dart';

class PulsingNode extends StatefulWidget {
  final double size;
  final Color color;
  final Widget child;
  const PulsingNode({
    super.key,
    required this.size,
    required this.color,
    required this.child,
  });

  @override
  State<PulsingNode> createState() => _PulsingNodeState();
}

class _PulsingNodeState extends State<PulsingNode>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 1.0,
      end: 1.18,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Transform.scale(
        scale: _pulse.value,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.5),
                blurRadius: 20 * _pulse.value,
                spreadRadius: 4 * _pulse.value,
              ),
            ],
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
