import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const LoadingAnimation(),
          const SvgLikeGooeySpinner(),
          Text(title, textAlign: TextAlign.center, style: context.titleMedium.semiBold),
          Text(subtitle, textAlign: TextAlign.center, style: context.bodyMedium),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

class SvgLikeGooeySpinner extends StatefulWidget {
  const SvgLikeGooeySpinner({super.key, this.size = 32});

  final double size;

  @override
  State<SvgLikeGooeySpinner> createState() => _SvgLikeGooeySpinnerState();
}

class _SvgLikeGooeySpinnerState extends State<SvgLikeGooeySpinner> with TickerProviderStateMixin {
  late final AnimationController _moveCtrl;
  late final AnimationController _rotateCtrl;

  @override
  void initState() {
    super.initState();

    _moveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat();
  }

  @override
  void dispose() {
    _moveCtrl.dispose();
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.size / 4;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_moveCtrl, _rotateCtrl]),
        builder: (_, __) {
          final t = Curves.easeInOut.transform(_moveCtrl.value);
          final dx = lerpDouble(-r * 1.6, r * 1.6, t)!;

          return Transform.rotate(
            angle: _rotateCtrl.value * 2 * pi,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _ball(Offset(dx, 0), r, const Color(0xFFDF2028)),

                _ball(Offset(-dx, 0), r, const Color(0xFF3361AD)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _ball(Offset offset, double r, Color color) {
    return Transform.translate(
      offset: offset,
      child: Container(
        width: r * 2,
        height: r * 2,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
