import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.thickness, this.height = 0, this.indent, this.endIndent, this.color});

  final double? thickness;
  final double? height;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness,
      height: height,
      indent: indent,
      endIndent: endIndent,
      color: color ?? context.colorScheme.surfaceContainerHigh,
    );
  }
}
