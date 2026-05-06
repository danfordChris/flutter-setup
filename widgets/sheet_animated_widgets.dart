import 'package:flutter/material.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class SheetSlideTransition extends StatelessWidget {
  final Widget child;
  final SheetController controller;
  final bool fromTop; // true: slide from top, false: from bottom
  final double initialValue;
  final Curve curve;

  const SheetSlideTransition({
    super.key,
    required this.child,
    required this.controller,
    this.fromTop = true,
    this.initialValue = 1,
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final animation = SheetOffsetDrivenAnimation(
      controller: controller,
      initialValue: initialValue,
      startOffset: null,
      endOffset: null,
    ).drive(CurveTween(curve: curve));

    final slideTween = Tween<Offset>(begin: fromTop ? const Offset(0, -1) : const Offset(0, 1), end: Offset.zero);

    return SlideTransition(position: animation.drive(slideTween), child: child);
  }
}

class SheetFadeTransition extends StatelessWidget {
  final Widget child;
  final SheetController controller;
  final double initialValue;
  final Curve curve;
  final bool fadeInOnExpand;

  const SheetFadeTransition({
    super.key,
    required this.child,
    required this.controller,
    this.initialValue = 1,
    this.curve = Curves.easeInOut,
    this.fadeInOnExpand = true,
  });

  @override
  Widget build(BuildContext context) {
    final baseAnimation = SheetOffsetDrivenAnimation(
      controller: controller,
      initialValue: initialValue,
      startOffset: null,
      endOffset: null,
    ).drive(CurveTween(curve: curve));

    final animation = fadeInOnExpand ? baseAnimation : baseAnimation.drive(Tween<double>(begin: 1, end: 0));

    return FadeTransition(opacity: animation, child: child);
  }
}

class SheetHorizontalSlideTransition extends StatelessWidget {
  final Widget child;
  final SheetController controller;
  final bool fromLeft; // true: slide from left, false: from right
  final double initialValue;
  final Curve curve;

  const SheetHorizontalSlideTransition({
    super.key,
    required this.child,
    required this.controller,
    this.fromLeft = true,
    this.initialValue = 1,
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final animation = SheetOffsetDrivenAnimation(
      controller: controller,
      initialValue: initialValue,
      startOffset: null,
      endOffset: null,
    ).drive(CurveTween(curve: curve));

    final slideTween = Tween<Offset>(begin: fromLeft ? const Offset(-1, 0) : const Offset(1, 0), end: Offset.zero);

    return SlideTransition(position: animation.drive(slideTween), child: child);
  }
}

class SheetScaleTransition extends StatelessWidget {
  final Widget child;
  final SheetController controller;
  final Curve curve;

  const SheetScaleTransition({super.key, required this.child, required this.controller, this.curve = Curves.easeInExpo});

  @override
  Widget build(BuildContext context) {
    final animation = SheetOffsetDrivenAnimation(
      controller: controller,
      initialValue: 1,
      startOffset: null,
      endOffset: null,
    ).drive(CurveTween(curve: Curves.easeInExpo));

    // Hide the button when the sheet is dragged down.
    return ScaleTransition(scale: animation, child: child);
  }
}

class SheetCrossFadeTransition extends StatelessWidget {
  final Widget expandedChild;
  final Widget collapsedChild;
  final SheetController controller;
  final double initialValue;
  final Curve curve;

  const SheetCrossFadeTransition({
    super.key,
    required this.expandedChild,
    required this.collapsedChild,
    required this.controller,
    this.initialValue = 1,
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final baseAnimation = SheetOffsetDrivenAnimation(
      controller: controller,
      initialValue: initialValue,
      startOffset: null,
      endOffset: null,
    ).drive(CurveTween(curve: curve));

    // Animation goes from 0 (collapsed) to 1 (expanded)
    final expandedOpacity = baseAnimation;
    final collapsedOpacity = baseAnimation.drive(Tween<double>(begin: 1, end: 0));

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        FadeTransition(opacity: collapsedOpacity, child: collapsedChild),
        FadeTransition(opacity: expandedOpacity, child: expandedChild),
      ],
    );
  }
}
