import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../../utils/extensions/extensions.dart';

enum InputBorderType { outline, underline, none }

/// Reusable form field styled from the app's [InputDecorationTheme].
///
/// Renders an optional label above the field (matches the design system's
/// external-label convention) and, when [obscureText] is true, an
/// eye-icon toggle so callers don't need to manage that state themselves.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.borderType = InputBorderType.outline,
    this.obscureText = false,
    this.isValid = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final InputBorderType borderType;
  final bool obscureText;

  /// Marks the field as validated (green border + check suffix), matching
  /// the style guide's "Valid" field state. Ignored while [obscureText] is
  /// true, since that state already owns the suffix slot.
  final bool isValid;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final FocusNode? focusNode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscureText;
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() => setState(() => _focused = _focusNode.hasFocus);

  void _toggleObscured() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    final field = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        borderRadius: AppRadius.radiusLg,
        boxShadow: _focused ? AppShadows.focusRing() : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: _obscured,
        enabled: widget.enabled,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        autofillHints: widget.autofillHints,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        style: AppTypography.body.copyWith(
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: _borderFor(AppColors.borderDefault),
          enabledBorder: _borderFor(
            widget.isValid ? AppColors.statusResolved : AppColors.borderDefault,
          ),
          focusedBorder: _borderFor(
            widget.isValid ? AppColors.statusResolved : AppColors.accent,
            width: 1.5,
          ),
          disabledBorder: _borderFor(AppColors.borderDefault),
          errorBorder: _borderFor(AppColors.statusRejected),
          focusedErrorBorder: _borderFor(AppColors.statusRejected, width: 1.5),
          prefixIcon: widget.prefixIcon == null
              ? null
              : Icon(widget.prefixIcon, size: AppIconSizes.md),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: AppIconSizes.md,
                  ),
                  onPressed: _toggleObscured,
                )
              : widget.isValid
              ? const Icon(Icons.check, color: AppColors.statusResolved)
              : widget.suffixIcon == null
              ? null
              : Icon(widget.suffixIcon, size: AppIconSizes.md),
        ),
      ),
    );

    if (widget.labelText == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText!, style: context.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs2),
        field,
      ],
    );
  }

  InputBorder _borderFor(Color color, {double width = 1}) {
    final side = BorderSide(color: color, width: width);
    return switch (widget.borderType) {
      InputBorderType.outline => OutlineInputBorder(
        borderRadius: AppRadius.radiusLg,
        borderSide: side,
      ),
      InputBorderType.underline => UnderlineInputBorder(borderSide: side),
      InputBorderType.none => InputBorder.none,
    };
  }
}
