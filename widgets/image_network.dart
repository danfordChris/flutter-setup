import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';

class ImageNetwork extends StatelessWidget {
  const ImageNetwork({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.placeholderSize = 30,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final double? placeholderSize;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: context.colorScheme.surfaceContainerLow,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: context.colorScheme.surfaceContainerLow,
        child:  Center(
          child:  HugeIcon(icon: HugeIcons.strokeRoundedLoading03, color: context.colorScheme.outline, size:placeholderSize ),
          // child: Icon(Icons.broken_image_outlined),
        ),
      ),
      fit: BoxFit.cover,
    );
  }
}
