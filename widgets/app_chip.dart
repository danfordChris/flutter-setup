import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onSelected,
    this.disabledColor,
    this.selectedColor,
    this.backgroundColor,
  });

  final String label;
  final bool isSelected;
  final void Function(bool)? onSelected;
  final Color? disabledColor;
  final Color? selectedColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Skeleton.leaf(
      child: ChoiceChip(
        label: Text(label),
        showCheckmark: false,
        selectedColor: selectedColor,
        disabledColor: disabledColor,
        backgroundColor: backgroundColor,
        selected: isSelected,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: context.colorScheme.surface),
          borderRadius: BorderRadius.circular(20.0),
        ),
        onSelected: onSelected,
      ),
    );
  }
}
