import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';

class NotchedContainer extends StatelessWidget {
  const NotchedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 30,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            top: 5,
            child: ClipPath(
              clipper: NotchedClipper(),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainer,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 65,
            height: 8,
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainer.withValues(alpha: 0.64),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}

class NotchedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double notchWidth = 70.0;
    const double notchDepth = 7.0;
    const double notchRadius = 6.0;
    final double centerX = size.width / 2;
    final double left = 0.0;
    final double right = size.width;
    final double startNotch = centerX - notchWidth / 2;
    final double endNotch = centerX + notchWidth / 2;

    final Path path = Path();

    path.moveTo(left, 0);
    path.lineTo(startNotch - notchRadius, 0);
    path.quadraticBezierTo(startNotch, 0, startNotch, notchRadius);
    path.lineTo(startNotch, notchDepth - notchRadius);
    path.quadraticBezierTo(startNotch, notchDepth, startNotch + notchRadius, notchDepth);
    path.lineTo(endNotch - notchRadius, notchDepth);
    path.quadraticBezierTo(endNotch, notchDepth, endNotch, notchDepth - notchRadius);
    path.lineTo(endNotch, notchRadius);
    path.quadraticBezierTo(endNotch, 0, endNotch + notchRadius, 0);
    path.lineTo(right, 0);
    path.lineTo(right, size.height);
    path.lineTo(left, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
