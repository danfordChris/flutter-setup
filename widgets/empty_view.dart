import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solomon/core/resources/resources.dart';
import 'package:solomon/services/strings.dart';
import 'package:solomon/shared/widgets/app_button.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, this.title, this.subtitle, this.child, this.action});

  final String? title;
  final String? subtitle;
  final Widget? child;
  final AppButton? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child ?? Image.asset(Images.basket, height: 150),
          Text(title ?? Strings.instance.noResultsFound, textAlign: TextAlign.center, style: context.titleMedium.semiBold),
          Text(subtitle ?? Strings.instance.couldNotFindResult, textAlign: TextAlign.center, style: context.bodyMedium),
          const SizedBox(height: 8.0),
          ?action,
        ],
      ),
    );
  }
}
