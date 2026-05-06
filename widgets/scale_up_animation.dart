import 'package:flutter/widgets.dart';

class ScaleUpAnimation extends StatefulWidget {
  final Widget child;
  final double initialScale;
  final Duration duration;
  final Duration delay;
  final Curve curve;

  const ScaleUpAnimation({
    super.key,
    required this.child,
    this.initialScale = 0.0,
    this.duration = Duration.zero,
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
  });

  @override
  State<ScaleUpAnimation> createState() => _ScaleUpAnimationState();
}

class _ScaleUpAnimationState extends State<ScaleUpAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<double>(begin: widget.initialScale, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    if (widget.delay > Duration.zero) {
      await Future.delayed(widget.delay);
    }
    if (mounted) _controller.forward();
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
      builder: (_, child) {
        return Transform.scale(scale: _animation.value, child: child);
      },
      child: widget.child,
    );
  }
}
