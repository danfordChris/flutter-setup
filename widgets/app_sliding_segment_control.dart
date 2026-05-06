import 'package:flutter/cupertino.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solomon/shared/widgets/app_container.dart';

class AppSlidingSegmentControl<T extends Object> extends StatelessWidget {
  const AppSlidingSegmentControl({super.key, this.groupValue, required this.children, required this.onValueChanged});

  final T? groupValue;
  final Map<T, Widget> children;
  final void Function(T?) onValueChanged;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12.0),
      child: CupertinoSlidingSegmentedControl<T>(
        groupValue: groupValue,
        thumbColor: context.colorScheme.surface,
        backgroundColor: context.colorScheme.surfaceContainerHigh,
        onValueChanged: onValueChanged,
        children: children,
      ),
    );
  }
}
