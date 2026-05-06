import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solar_icon_pack/solar_linear_icons.dart';
import 'package:solomon/shared/widgets/app_button.dart';
import 'package:solomon/shared/widgets/app_divider.dart';

class AppBottomsheet extends StatelessWidget {
  const AppBottomsheet({super.key, required this.title, this.subtitle, required this.child, this.appButtons = const []});

  final String title;
  final String? subtitle;
  final List<AppButton> appButtons;
  final Widget child;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    List<AppButton> appButtons = const [],
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    bool useRootNavigator = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.0))),
      builder: (context) => AppBottomsheet(title: title, subtitle: subtitle, appButtons: appButtons, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16.0, top: 8.0),
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
                      Text(title, style: context.titleMedium.semiBold),
                      if (subtitle != null) Text(subtitle!),
                    ],
                  ),
                ),
                IconButton(onPressed: () => context.pop(), icon: const Icon(SolarLinearIcons.close)),
              ],
            ),
            const AppDivider(height: 15.0),
            child,
            if (appButtons.isNotEmpty) ...[const Gap(15.0), _buildButtonsRow(context)],
          ],
        ),
      ),
    );
  }

  Widget _buildButtonsRow(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Row(spacing: 8.0, children: appButtons.map((button) => Expanded(child: button)).toList()),
      ),
    );
  }
}
