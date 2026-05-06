import 'package:flutter/material.dart';

class TripleRail extends StatelessWidget {
  const TripleRail({super.key, this.left, this.center, this.right});

  final Widget? left;
  final Widget? center;
  final Widget? right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(alignment: Alignment.centerLeft, child: left),
        ),
        if (center != null) center!,
        Expanded(
          child: Align(alignment: Alignment.centerRight, child: right),
        ),
      ],
    );
  }
}
