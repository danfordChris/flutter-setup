import 'package:flutter/material.dart';
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
import 'package:solomon/core/resources/resources.dart';
import 'package:solomon/services/strings.dart';

const double _defaultSize = 56.0;

enum AppLogoType { icon, horizontal, vertical, text }

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = _defaultSize, this.type = AppLogoType.icon, this.spacing, this.textColor});

  final double? size;
  final AppLogoType? type;
  final double? spacing;
  final Color? textColor;

  const AppLogo.vertical({super.key, this.size = _defaultSize, this.spacing, this.textColor}) : type = AppLogoType.vertical;
  const AppLogo.horizontal({super.key, this.size = _defaultSize, this.spacing, this.textColor}) : type = AppLogoType.horizontal;
  const AppLogo.text({super.key, this.size = _defaultSize, this.textColor}) : type = AppLogoType.text, spacing = null;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      AppLogoType.horizontal => _buildHorizontalLogo(context),
      AppLogoType.vertical => _buildVerticalLogo(context),
      AppLogoType.text => _buildTextLogo(context),
      _ => _buildIconLogo(),
    };
  }

  Widget _buildIconLogo() {
    return Image.asset(Images.logo, height: size, width: size);
  }

  Widget _buildVerticalLogo(BuildContext context) {
    return Column(
      spacing: spacing ?? 0.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Images.logo, height: size, width: size),
        _getWordMark(context),
      ],
    );
  }

  Widget _buildHorizontalLogo(BuildContext context) {
    return Row(
      spacing: spacing ?? 0.0,
      children: [_buildIconLogo(), _getWordMark(context, CrossAxisAlignment.start)],
    );
  }

  Widget _getWordMark(BuildContext context, [CrossAxisAlignment? crossAxisAlignment]) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTextLogo(context),
        Text(Strings.instance.stockbrokersWordmark, style: context.bodyMedium.copyWith(height: 1.0, color: textColor)),
      ],
    );
  }

  Widget _buildTextLogo(BuildContext context) {
    return Text(
      Strings.instance.solomonWordmark,
      style: context.titleLarge.bold.copyWith(height: 1.0, color: textColor, fontSize: type == AppLogoType.text ? size : null),
    );
  }
}
