import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:solomon/shared/widgets/keypad_button.dart';

class PinKeypad<T> extends StatelessWidget {
  const PinKeypad({
    super.key,
    this.onKeyPressed,
    this.onBackspacePressed,
    this.onBiometricsPressed,
    this.enableBiometrics = true,
    this.enableBackspace = true,
  });

  final void Function(int?)? onKeyPressed;
  final void Function(int?)? onBackspacePressed;
  final void Function()? onBiometricsPressed;
  final bool enableBiometrics;
  final bool enableBackspace;

  List<int> get _keys => [1, 2, 3, 4, 5, 6, 7, 8, 9, -1, 0, -2];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 2.0,
      ),
      itemCount: _keys.length,
      itemBuilder: (context, index) {
        final int key = _keys[index];
        if (key == -1) {
          if (!enableBiometrics) return const SizedBox.shrink();
          return IconButton(
            icon: Icon(SolarLinearIcons.faceScanSquare, color: context.colorScheme.primary),
            onPressed: () {
              if (enableBiometrics) onBiometricsPressed?.call();
            },
          );
        } else if (key == -2) {
          if (!enableBackspace) return const SizedBox.shrink();
          return IconButton(
            icon: Icon(SolarLinearIcons.backspace, color: context.colorScheme.primary),
            onPressed: () => onBackspacePressed?.call(key),
          );
        } else {
          return KeypadButton<int>(label: key.toString(), value: key, onPressed: onKeyPressed);
        }
      },
    );
  }
}
