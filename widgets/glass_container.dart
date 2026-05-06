import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.color,
    this.borderColor,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
  }) : icon = null;

  GlassContainer.icon({super.key, required this.icon, this.color, this.width = 45, this.height = 45, this.onTap})
    : borderColor = null,
      padding = EdgeInsets.zero,
      borderRadius = BorderRadius.circular(50.0),
      child = const SizedBox.shrink();

  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double? width;
  final double? height;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = this.borderRadius ?? BorderRadius.circular(16.0);
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? context.colorScheme.primary.withValues(alpha: 0.03),
          border: GradientBoxBorder(
            width: 2,
            gradient: LinearGradient(
              colors: [Colors.white.withValues(alpha: 0.1), Colors.grey.withValues(alpha: 0.3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16.0),
              child: icon ?? child,
            ),
          ),
        ),
      ),
    );
  }
}
