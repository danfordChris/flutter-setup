import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({super.key, required this.icon, this.onPressed});

  final Widget icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: icon,
      style: IconButton.styleFrom(
        iconSize: 20,
        fixedSize: const Size.square(30.0),
        minimumSize: const Size.square(30.0),
        padding: EdgeInsets.zero,
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        foregroundColor: Colors.white,
      ),
    );
  }
}
