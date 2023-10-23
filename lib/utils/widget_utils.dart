import 'package:flutter/material.dart';

class WidgetUtils {
  static TextFormField buildCustomField({
    required TextEditingController controller,
    required String hintText,
    TextStyle? textStyle,
    InputDecoration? inputDecoration,
    String? Function(String?)? validator,
    String? initialValue,
    String? errorText,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      style: textStyle ?? const TextStyle(color: Colors.black),
      decoration: inputDecoration ??
          InputDecoration(
            fillColor: Colors.grey.shade100,
            filled: true,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
      obscureText: obscureText,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return errorText;
            }
            return null;
          },
      initialValue: initialValue,
    );
  }
}
