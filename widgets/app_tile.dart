import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:solomon/core/theme/custom_colors.dart';
import 'package:solomon/shared/widgets/app_container.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isSelected = false,
    this.showSelectedIcon = true,
    this.height,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.color,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isSelected;
  final bool showSelectedIcon;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final void Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      color: color,
      borderRadius: borderRadius,
      borderColor: isSelected ? context.colorScheme.primary : context.customColors.surface,
      child: ListTile(
        minTileHeight: height,
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: _buildTrailing(context),
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
      ),
    );
  }

  Widget? _buildTrailing(BuildContext context) {
    return showSelectedIcon
        ? isSelected
              ? Icon(SolarBoldIcons.checkCircle, color: context.colorScheme.primary)
              : Icon(SolarLinearIcons.stop, color: context.colorScheme.outline)
        : trailing;
  }
}
