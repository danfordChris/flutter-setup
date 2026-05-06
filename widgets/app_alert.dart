import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum AlertType { success, error, info, warning }

class AppAlert {
  AppAlert._();

  // static show({required String message, bool showIcon = true, AlertType type = AlertType.info}) {
  //   toastification.show(
  //     type: _toastificationType(type),
  //     style: ToastificationStyle.flatColored,
  //     closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
  //     title: Text(message),
  //     description: RichText(text: const TextSpan(text: 'This is a sample toast message.')),
  //     icon: const Icon(Icons.check),
  //     closeOnClick: true,
  //     alignment: Alignment.bottomCenter, // changed from topCenter to bottomCenter
  //     autoCloseDuration: const Duration(seconds: 3),
  //     animationBuilder: (context, animation, alignment, child) {
  //       return FadeTransition(opacity: animation, child: child);
  //     },
  //     borderRadius: BorderRadius.circular(10.0),
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     showIcon: showIcon,
  //   );
  // }

  static show({required String message, AlertType type = AlertType.info}) {
    toastification.show(
      type: _toastificationType(type),
      style: ToastificationStyle.simple,
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.none),
      title: Text(message),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      borderRadius: BorderRadius.circular(30.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      showIcon: false,
    );
  }

  static ToastificationType _toastificationType(AlertType type) {
    return switch (type) {
      AlertType.success => ToastificationType.success,
      AlertType.error => ToastificationType.error,
      AlertType.info => ToastificationType.info,
      AlertType.warning => ToastificationType.warning,
    };
  }
}
