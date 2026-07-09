import 'package:flutter/material.dart';

enum InputBorderType {
  outline,
  underline,
  none,
}

class CustomFormField extends StatefulWidget {
  const CustomFormField({
    super.key,
    this.borderType = InputBorderType.outline,
  });

  final InputBorderType borderType;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  final ValueNotifier<bool> _isObscure = .new(true);

  @override
  void dispose() {
    _isObscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isObscure,
      builder: (context, isObscure, child) {
        return TextFormField(
          decoration: InputDecoration(
            border: _border,
          ),
        );
      },
    );
  }

  InputBorder get _border => switch (widget.borderType) {
    InputBorderType.outline => const OutlineInputBorder(),
    InputBorderType.underline => const UnderlineInputBorder(),
    InputBorderType.none => InputBorder.none,
  };
}
