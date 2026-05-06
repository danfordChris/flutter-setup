import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solomon/core/resources/resources.dart';
import 'package:solomon/services/strings.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.imageAsset,
    required this.title,
    this.description,
  });
  final String? imageAsset;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imageAsset ?? Images.basket,
              height: 100,
            ),
            const Gap(12),
            Text(
              title,
              style: context.titleMedium.bold,
            ),
            const Gap(6),
            Text(
              description ?? Strings.instance.updatesWillAppearOncePublished,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
