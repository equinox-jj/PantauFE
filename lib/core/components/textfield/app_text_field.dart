import 'package:flutter/material.dart';

enum InputBorderType {
  outline,
  underline,
  none,
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.borderType = InputBorderType.outline,
  });

  final TextEditingController? controller;
  final InputBorderType borderType;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
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
      builder: (context, isObscure, _) {
        return TextFormField(
          controller: widget.controller,
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
