import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:solomon/core/theme/custom_colors.dart';
import 'package:solomon/shared/widgets/glass_container.dart';

enum AppButtonVariant { primary, secondary, tertiary, outline, surface, text, success, destructive, red, glass, glassIcon }

enum IconPosition { start, end }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    this.title,
    this.onPressed,
    this.icon,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.enabled = true,
    this.loading = false,
    this.expands = false,
    this.borderRadius,
    this.iconPosition = IconPosition.start,
    this.iconColor,
    this.variant = AppButtonVariant.primary,
  }) : boxShadow = null,
       assert(title != null || icon != null, 'Either title or leading icon must be provided');

  const AppButton.primary({
    super.key,
    this.title,
    this.onPressed,
    this.icon,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.enabled = true,
    this.loading = false,
    this.expands = false,
    this.borderRadius,
    this.iconPosition = IconPosition.start,
    this.iconColor,
    this.variant = AppButtonVariant.primary,
  }) : boxShadow = null,
       assert(title != null || icon != null, 'Either title or leading icon must be provided');

  const AppButton.secondary({
    super.key,
    this.title,
    this.onPressed,
    this.icon,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.enabled = true,
    this.loading = false,
    this.expands = false,
    this.borderRadius,
    this.iconPosition = IconPosition.start,
    this.iconColor,
    this.variant = AppButtonVariant.secondary,
  }) : boxShadow = null,
       assert(title != null || icon != null, 'Either title or leading icon must be provided');

  const AppButton.tertiary({
    super.key,
    this.title,
    this.onPressed,
    this.icon,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.enabled = true,
    this.loading = false,
    this.expands = false,
    this.borderRadius,
    this.iconPosition = IconPosition.start,
    this.iconColor,
    this.variant = AppButtonVariant.tertiary,
  }) : boxShadow = null,
       assert(title != null || icon != null, 'Either title or leading icon must be provided');

  const AppButton.outline({
    super.key,
    this.title,
    this.onPressed,
    this.icon,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.enabled = true,
    this.loading = false,
    this.expands = false,
    this.borderRadius,
    this.iconPosition = IconPosition.start,
    this.iconColor,
    this.variant = AppButtonVariant.outline,
  }) : boxShadow = null,
       assert(title != null || icon != null, 'Either title or leading icon must be provided');

  const AppButton.surface({
    super.key,
    this.title,
    this.onPressed,
    this.icon,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.enabled = true,
    this.loading = false,
    this.expands = false,
    this.borderRadius,
    this.iconPosition = IconPosition.start,
    this.iconColor,
    this.boxShadow,
    this.variant = AppButtonVariant.surface,
  }) : assert(title != null || icon != null, 'Either title or leading icon must be provided');

  const AppButton.text({
    super.key,
    this.title,
    this.onPressed,
    this.icon,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.enabled = true,
    this.loading = false,
    this.expands = false,
    this.borderRadius,
    this.iconPosition = IconPosition.start,
    this.iconColor,
    this.variant = AppButtonVariant.text,
  }) : boxShadow = null,
       assert(title != null || icon != null, 'Either title or leading icon must be provided');

  const AppButton.success({
    super.key,
    this.title,
    this.onPressed,
    this.icon,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.enabled = true,
    this.loading = false,
    this.expands = false,
    this.borderRadius,
    this.iconPosition = IconPosition.start,
    this.iconColor,
    this.variant = AppButtonVariant.success,
  }) : boxShadow = null,
       assert(title != null || icon != null, 'Either title or leading icon must be provided');

  const AppButton.destructive({
    super.key,
    this.title,
    this.onPressed,
    this.icon,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.enabled = true,
    this.loading = false,
    this.expands = false,
    this.borderRadius,
    this.iconPosition = IconPosition.start,
    this.iconColor,
    this.variant = AppButtonVariant.destructive,
  }) : boxShadow = null,
       assert(title != null || icon != null, 'Either title or leading icon must be provided');

  const AppButton.red({
    super.key,
    this.title,
    this.onPressed,
    this.icon,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.enabled = true,
    this.loading = false,
    this.expands = false,
    this.borderRadius,
    this.iconPosition = IconPosition.start,
    this.iconColor,
    this.variant = AppButtonVariant.red,
  }) : boxShadow = null,
       assert(title != null || icon != null, 'Either title or leading icon must be provided');

  const AppButton.glass({
    super.key,
    this.title,
    this.onPressed,
    this.icon,
    this.textStyle,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.enabled = true,
    this.loading = false,
    this.expands = true,
    this.borderRadius,
    this.iconPosition = IconPosition.start,
    this.iconColor,
    this.variant = AppButtonVariant.glass,
  }) : boxShadow = null,
       assert(title != null || icon != null, 'Either title or leading icon must be provided');

  const AppButton.glassIcon({
    super.key,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.enabled = true,
    this.loading = false,
    this.borderRadius,
    this.iconColor,
    this.variant = AppButtonVariant.glassIcon,
  }) : textStyle = null,
       title = null,
       expands = false,
       height = 45,
       iconPosition = null,
       borderColor = null,
       boxShadow = null;

  final VoidCallback? onPressed;
  final IconData? icon;
  final String? title;
  final TextStyle? textStyle;
  final AppButtonVariant variant;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool enabled;
  final bool loading;
  final bool expands;
  final double? borderRadius;
  final IconPosition? iconPosition;
  final Color? iconColor;
  final List<BoxShadow>? boxShadow;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    Widget button = AbsorbPointer(
      absorbing: !widget.enabled || widget.loading,
      child: _buildWrapper(
        FilledButton.icon(style: _buttonStyle, onPressed: widget.enabled ? _onPressed : null, icon: _buildIcon, label: _buildLabel!),
      ),
    );
    return widget.expands ? _expanded(button) : button;
  }

  Widget _buildWrapper(Widget child) {
    if (widget.variant == AppButtonVariant.glass) {
      return GlassContainer(
        height: widget.height,
        padding: EdgeInsets.zero,
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.0),
        child: _expanded(child),
      );
    }
    if (widget.variant == AppButtonVariant.glassIcon) {
      return GlassContainer(
        height: widget.height,
        width: widget.height,
        padding: EdgeInsets.zero,
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.0),
        child: IconButton(
          onPressed: widget.enabled ? _onPressed : null,
          icon: Icon(widget.icon, size: 20, color: widget.iconColor ?? Colors.white),
        ),
      );
    }
    return Skeleton.unite(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.0), gradient: _gradient, boxShadow: widget.boxShadow),
        child: child,
      ),
    );
  }

  ButtonStyle get _buttonStyle {
    return FilledButton.styleFrom(
      backgroundColor: _backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.0)),
      side: BorderSide(color: _borderColor),
      minimumSize: widget.height != null ? Size(0, widget.height!) : const Size(64, 45),
    );
  }

  Widget? get _buildIcon {
    if (widget.iconPosition == IconPosition.end) {
      return _label;
    }
    return _icon;
  }

  Widget? get _buildLabel {
    if (widget.iconPosition == IconPosition.end) {
      if (widget.icon == null || widget.title == null) {
        return const SizedBox.shrink();
      }
      return _icon;
    }
    return _label;
  }

  Widget? get _icon {
    if (widget.icon == null || widget.title == null) return null;
    if (widget.loading) return _loadingIndicator;
    return Icon(widget.icon, color: widget.iconColor ?? _foregroundColor);
  }

  Widget get _label {
    if (widget.loading && widget.icon == null) return _loadingIndicator;
    if (widget.title == null && widget.icon != null) {
      return widget.loading ? _loadingIndicator : Icon(widget.icon, color: _foregroundColor);
    }
    return Text(widget.title!, style: widget.textStyle ?? context.titleMedium.medium.copyWith(color: _foregroundColor));
  }

  Widget get _loadingIndicator {
    return SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2, color: _foregroundColor));
  }

  Color get _backgroundColor {
    return switch (widget.variant) {
      AppButtonVariant.primary => widget.backgroundColor ?? context.colorScheme.primary,
      AppButtonVariant.secondary => widget.backgroundColor ?? context.colorScheme.secondary,
      AppButtonVariant.tertiary => widget.backgroundColor ?? context.colorScheme.tertiary,
      // AppButtonVariant.outline => widget.backgroundColor ?? Colors.transparent,
      AppButtonVariant.outline => Colors.transparent,
      AppButtonVariant.surface => widget.backgroundColor ?? context.colorScheme.surface,
      AppButtonVariant.text => widget.backgroundColor ?? Colors.transparent,
      AppButtonVariant.success => widget.backgroundColor ?? context.customColors.successContainer,
      AppButtonVariant.destructive => widget.backgroundColor ?? context.customColors.destructiveContainer,
      AppButtonVariant.red => widget.backgroundColor ?? context.colorScheme.error,
      AppButtonVariant.glass => Colors.transparent,
      AppButtonVariant.glassIcon => Colors.transparent,
    };
  }

  Color get _borderColor {
    return switch (widget.variant) {
      AppButtonVariant.outline => widget.borderColor ?? context.colorScheme.primary,
      AppButtonVariant.glass => Colors.transparent,
      _ => widget.backgroundColor ?? Colors.transparent,
    };
  }

  Color get _foregroundColor {
    if (!widget.enabled) return context.colorScheme.outline;
    return switch (widget.variant) {
      AppButtonVariant.primary => context.colorScheme.onPrimary,
      AppButtonVariant.secondary => context.colorScheme.onSecondary,
      AppButtonVariant.tertiary => context.colorScheme.primary,
      // AppButtonVariant.outline => context.colorScheme.primary,
      AppButtonVariant.outline => context.colorScheme.onSurface,
      AppButtonVariant.surface => context.colorScheme.onSurface,
      AppButtonVariant.text => context.colorScheme.onSurface,
      AppButtonVariant.success => context.customColors.onSuccessContainer,
      AppButtonVariant.destructive => context.customColors.onDestructiveContainer,
      AppButtonVariant.red => context.customColors.onRedContainer,
      AppButtonVariant.glass => Colors.white,
      AppButtonVariant.glassIcon => Colors.white,
    };
  }

  Gradient? get _gradient {
    if (!widget.enabled) return null;
    return switch (widget.variant) {
      AppButtonVariant.primary => LinearGradient(
        colors: [context.colorScheme.primaryFixed.withValues(alpha: 0.2), context.colorScheme.secondary],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      AppButtonVariant.secondary => LinearGradient(
        colors: [context.colorScheme.primary.withValues(alpha: 0.4), context.colorScheme.secondary.withValues(alpha: 0.4)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      AppButtonVariant.tertiary => LinearGradient(
        colors: [context.colorScheme.tertiary.withValues(alpha: 0.2), context.colorScheme.secondary.withValues(alpha: 0.2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      AppButtonVariant.surface => LinearGradient(
        colors: [context.colorScheme.surface, context.colorScheme.surface],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      AppButtonVariant.success => const LinearGradient(
        colors: [Color(0xFF81F0C2), Color(0x0A332233)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      AppButtonVariant.destructive => LinearGradient(
        colors: [context.colorScheme.errorContainer.withValues(alpha: 0.2), context.colorScheme.error.withValues(alpha: 0.2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      AppButtonVariant.red => LinearGradient(
        colors: [context.colorScheme.errorContainer.withValues(alpha: 0.4), context.customColors.redContainer.withValues(alpha: 0.2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      _ => null,
    };
  }

  Widget _expanded(Widget child) {
    return Row(children: [Expanded(child: child)]);
  }

  void _onPressed() {
    if (widget.onPressed == null) return;
    widget.onPressed!();
  }
}
