import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solar_icon_pack/solar_linear_icons.dart';
import 'package:solomon/services/strings.dart';

class AppPopupMenuButton<T> extends StatelessWidget {
  const AppPopupMenuButton({
    super.key,
    this.initialValue,
    this.selected,
    this.onSelected,
    required this.items,
    this.itemLabel,
  });

  final T? initialValue;
  final T? selected;
  final void Function(T)? onSelected;
  final List<T> items;
  final String Function(T)? itemLabel;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: context.colorScheme.outlineVariant),
        ),
        child: Row(
          spacing: 4.0,
          children: [
            Text(
              selected == null ? Strings.instance.commonSelect : (itemLabel?.call(selected as T) ?? selected.toString()),
              style: context.labelMedium,
            ),
            const Icon(
              SolarLinearIcons.altArrowDown,
              size: 20,
            ),
          ],
        ),
      ),
      initialValue: initialValue,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => items
          .map(
            (i) => PopupMenuItem<T>(
              value: i,
              child: Text(itemLabel?.call(i) ?? i.toString()),
            ),
          )
          .toList(),
    );
  }
}
