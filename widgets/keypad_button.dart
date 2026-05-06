import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solomon/shared/widgets/app_button.dart';
import 'package:solomon/shared/widgets/helper_widgets.dart';

class KeypadButton<T> extends StatelessWidget {
  const KeypadButton({super.key, required this.label, required this.value, this.textStyle, this.backgroundColor, this.onPressed});

  final String label;
  final T value;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final void Function(T value)? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.surface(
      title: label,
      backgroundColor: backgroundColor,
      boxShadow: [HelperWidgets.shadow(context)],
      textStyle: textStyle ?? context.titleLarge.semiBold.copyWith(color: context.colorScheme.primary),
      onPressed: () {
        if (onPressed != null) {
          onPressed!(value ?? label as T);
        }
      },
    );
  }
}
