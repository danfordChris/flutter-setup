import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solomon/core/theme/custom_colors.dart';
import 'package:solomon/shared/widgets/app_container.dart';
import 'package:solomon/shared/widgets/app_divider.dart';

class AppExpansionTile extends StatelessWidget {
  const AppExpansionTile({super.key, required this.title, required this.body, this.isExpanded = true, this.onExpansionChanged});

  final Widget title;
  final Widget body;
  final bool isExpanded;
  final Function(bool)? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(20.0),
      borderColor: isExpanded ? context.colorScheme.primary : context.customColors.surface,
      child: ExpansionTile(
        key: key,
        initiallyExpanded: isExpanded,
        onExpansionChanged: onExpansionChanged,
        iconColor: context.colorScheme.outline,
        collapsedIconColor: context.colorScheme.outline,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: title,
        children: [
          AppDivider(height: 0.5, indent: 16, endIndent: 16, color: context.colorScheme.surfaceContainerHighest),
          body,
        ],
      ),
    );
  }
}
