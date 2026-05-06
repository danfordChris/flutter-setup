import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solomon/shared/widgets/app_divider.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.appButtons = const [],
  });

  final String title;
  final String? subtitle;
  final List<Widget> appButtons;
  final Widget child;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    required Widget child,
    List<Widget> appButtons = const [],
    bool barrierDismissible = true,
    bool useRootNavigator = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: AppDialog(
          title: title,
          subtitle: subtitle,
          appButtons: appButtons,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: context.themeData.cardColor,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: context.colorScheme.surfaceContainerHighest),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(8.0),
                      Text(title, style: context.titleLarge),
                      if (subtitle != null) Text(subtitle!),
                    ],
                  ),
                ),
              ],
            ),

            const AppDivider(height: 15.0),
            child,
            if (appButtons.isNotEmpty) ...[
              const Gap(15.0),
              Row(
                spacing: 12,
                children: appButtons.map((button) => Expanded(child: button)).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
