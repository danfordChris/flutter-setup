import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';

class DottedContainer extends StatelessWidget {
  final Widget child;
  final Color? borderColor;

  const DottedContainer({super.key, required this.child, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: [10, 5],
        strokeWidth: 2,
        radius: const Radius.circular(20),
        color: borderColor ?? context.colorScheme.primaryFixedDim,
        // padding: const EdgeInsets.all(16),
      ),
      child: child,
    );
  }
}
