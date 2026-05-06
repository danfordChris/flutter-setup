import 'package:flutter/material.dart';
import 'package:form_shield/form_shield.dart';
import 'package:solomon/services/strings.dart';
import 'package:solomon/shared/widgets/input_fields.dart';

class OtpField extends StatelessWidget {
  final TextEditingController controller;
  final int pinLength;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onSubmitted;
  final List<ValidationRule<String>>? validationRule;

  const OtpField({
    super.key,
    required this.controller,
    this.pinLength = 4,
    this.onCompleted,
    this.onSubmitted,
    this.validationRule,
  });

  @override
  Widget build(BuildContext context) {
    return InputField.pin(
      pinLength: pinLength,
      controller: controller,
      validator: validator([RequiredRule(errorMessage: Strings.instance.thisFieldIsRequired), LengthRule(minLength: pinLength), ...?validationRule]),
      onCompleted: onCompleted,
      onSubmitted: onSubmitted,
    );
  }
}
