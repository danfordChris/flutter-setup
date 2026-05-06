import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solomon/core/theme/custom_colors.dart';
import 'package:solomon/shared/widgets/helper_widgets.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({super.key, required this.child, this.color, this.borderColor, this.padding, this.borderRadius, this.onTap});

  final Widget child;
  final Color? color;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    BorderRadius effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16.0);
    return InkWell(
      borderRadius: effectiveBorderRadius,
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16.0),
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          color: color ?? context.colorScheme.surfaceBright,
          borderRadius: effectiveBorderRadius,
          boxShadow: [HelperWidgets.shadow(context)],
          border: Border.all(color: borderColor ?? context.customColors.surface, width: 2.0),
        ),
        child: child,
      ),
    );
  }
}
