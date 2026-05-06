import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.scale = 1.0, this.backgroundColor, this.foregroundColor});

  final double scale;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: IconButton.filled(
        onPressed: () {
          if (context.canPop()) context.pop();
        },
        icon: const Icon(SolarLinearIcons.altArrowLeft),
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor ?? context.colorScheme.surface,
          foregroundColor: foregroundColor ?? context.colorScheme.onSurface,
        ),
      ),
    );
  }
}
