import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solomon/services/strings.dart';
import 'package:solomon/shared/widgets/app_container.dart';
import 'package:solomon/shared/widgets/helper_widgets.dart';

enum AppRadioVariant { standard, tile, chip }

class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.subtitle,
    this.leading,
    this.isEnabled = true,
    this.variant = AppRadioVariant.standard,
  });

  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final String? label;
  final String? subtitle;
  final Widget? leading;
  final bool isEnabled;
  final AppRadioVariant variant;

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppRadioVariant.tile:
        return _buildTile(context);
      case AppRadioVariant.chip:
        return _buildChip(context);
      default:
        return _buildStandard(context);
    }
  }

  Widget _buildStandard(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1 : 0.4,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isEnabled ? () => onChanged?.call(value) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RadioIndicator(isSelected: _isSelected),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(label!, style: context.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1 : 0.4,
      child: AppContainer(
        borderColor: _isSelected ? context.colorScheme.primary : null,
        onTap: isEnabled ? () => onChanged?.call(value) : null,
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (label != null) Text(label!, style: context.bodyMedium.semiBold),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: context.bodySmall.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            _RadioIndicator(isSelected: _isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2), // for border
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // same as input
      ),
      child: GestureDetector(
        onTap: isEnabled ? () => onChanged?.call(value) : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12), // same as input
            border: Border.all(
              color: context.colorScheme.surface,
              width: 2,
            ),
            boxShadow: [HelperWidgets.shadow(context)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                _isSelected ? Icons.radio_button_checked : Icons.circle_outlined,
                size: 20,
                color: _isSelected ? context.colorScheme.primary : context.colorScheme.outline,
              ),
              const SizedBox(width: 8),
              Text(
                label ?? '',
                style: context.bodyMedium.copyWith(color: _isSelected ? context.colorScheme.onSurface : context.colorScheme.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({
    super.key,
    required this.items,
    required this.groupValue,
    required this.onChanged,
    this.labelText,
    this.itemLabel,
    this.itemSubtitle,
    this.itemLeading,
    this.variant = AppRadioVariant.standard,
    this.direction = Axis.vertical,
    this.spacing = 8,
    this.isEnabled = true,
    this.validator,
    this.onSaved,
  });

  final List<T> items;
  final T? groupValue;
  final void Function(T?) onChanged;
  final String Function(T)? itemLabel;
  final String? labelText;
  final String Function(T)? itemSubtitle;
  final Widget Function(T)? itemLeading;
  final AppRadioVariant variant;
  final Axis direction;
  final double spacing;
  final bool isEnabled;
  final String? Function(T?)? validator;
  final void Function(T?)? onSaved;

  String _label(T item) => itemLabel != null ? itemLabel!(item) : item.toString();

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: groupValue,
      validator:
          validator ??
          (value) {
            if (value == null) {
              return Strings.instance.selectionRequired;
            }
            return null;
          },
      onSaved: onSaved,
      builder: (field) {
        final children = items.map((item) {
          return AppRadio<T>(
            value: item,
            groupValue: field.value,
            onChanged: isEnabled
                ? (val) {
                    field.didChange(val);
                    onChanged(val);
                  }
                : null,
            label: _label(item),
            subtitle: itemSubtitle?.call(item),
            leading: itemLeading?.call(item),
            variant: variant,
            isEnabled: isEnabled,
          );
        }).toList();

        Widget radioList;
        if (direction == Axis.horizontal) {
          radioList = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (labelText != null) Text(labelText!, style: context.bodySmall),
              Row(
                children: [
                  for (int i = 0; i < children.length; i++) ...[
                    Expanded(child: children[i]),
                    if (i < children.length - 1) SizedBox(width: spacing),
                  ],
                ],
              ),
            ],
          );
        } else {
          radioList = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1) SizedBox(height: spacing),
              ],
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            radioList,
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? context.colorScheme.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? context.colorScheme.primary : context.colorScheme.outline,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.onPrimary,
                ),
              ),
            )
          : null,
    );
  }
}
