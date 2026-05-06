import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solomon/core/theme/custom_colors.dart';

enum BottomsheetAlertType { info, warning, error, success }

class BottomsheetAlert extends StatelessWidget {
  const BottomsheetAlert({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.child,
    this.appButtons = const [],
    this.type = BottomsheetAlertType.info,
  });

  final String title;
  final String? subtitle;
  final List<Widget> appButtons;
  final BottomsheetAlertType type;
  final IconData icon;
  final Widget child;

  static Future<T?> show<T>(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    List<Widget> appButtons = const [],
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    BottomsheetAlertType type = BottomsheetAlertType.info,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.0))),
      builder: (context) => BottomsheetAlert(icon: icon, title: title, subtitle: subtitle, appButtons: appButtons, type: type, child: child),
    );
  }

  final double _containerSize = 85.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: context.themeData.cardColor,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: context.colorScheme.surfaceContainerHighest),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(_containerSize / 1.5),
              Text(title, style: context.titleLarge.semiBold, textAlign: TextAlign.center),
              const Gap(8.0),
              if (subtitle != null) Text(subtitle!, textAlign: TextAlign.center),
              child,
              if (appButtons.isNotEmpty) ...[_buildButtons(context)],
            ],
          ),
        ),
        Positioned(
          top: -50,
          child: _buildLeading(context),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          spacing: 8.0,
          mainAxisSize: MainAxisSize.min,
          children: appButtons.map((button) => button).toList(),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Container(
      width: _containerSize,
      height: _containerSize,
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            offset: const Offset(0, 6),
            color: context.colorScheme.shadow.withValues(alpha: 0.2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: _getForegroundColor(context),
        size: 30.0,
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    return switch (type) {
      BottomsheetAlertType.info => context.colorScheme.primary,
      BottomsheetAlertType.warning => context.colorScheme.errorContainer,
      BottomsheetAlertType.error => context.colorScheme.errorContainer,
      BottomsheetAlertType.success => context.customColors.successContainer,
    };
  }

  Color _getForegroundColor(BuildContext context) {
    return switch (type) {
      BottomsheetAlertType.info => context.colorScheme.onPrimary,
      BottomsheetAlertType.warning => context.colorScheme.onErrorContainer,
      BottomsheetAlertType.error => context.customColors.onErrorContainer,
      BottomsheetAlertType.success => context.customColors.onSuccessContainer,
    };
  }
}
