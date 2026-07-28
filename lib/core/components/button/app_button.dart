import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  secondary,
  ghost,
  destructive,
}

enum AppButtonSize {
  small(40),
  medium(48),
  large(56);

  const AppButtonSize(this.height);

  final double height;
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.leading,
    this.trailing,
    this.iconSpacing = 8,
    this.textStyle,
    this.isLoading = false,
    this.expanded = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final AppButtonSize size;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Widget? leading;
  final Widget? trailing;
  final double iconSpacing;
  final TextStyle? textStyle;
  final bool isLoading;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final style = _buttonStyle(context);
    Widget button;

    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.destructive:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: _buildChild(context),
        );

      case ButtonVariant.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: _buildChild(context),
        );

      case ButtonVariant.ghost:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: _buildChild(context),
        );
    }

    if (!expanded) {
      return button;
    }

    return SizedBox(
      width: width ?? double.infinity,
      child: button,
    );
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _foregroundColor(context),
        ),
      );
    }

    final children = <Widget>[
      if (leading != null) ...[
        IconTheme.merge(
          data: IconThemeData(
            size: textStyle?.fontSize != null
                ? (textStyle?.fontSize ?? 0) + 2
                : 20,
          ),
          child: leading!,
        ),
        SizedBox(width: iconSpacing),
      ],
      Flexible(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      if (trailing != null) ...[
        SizedBox(width: iconSpacing),
        IconTheme.merge(
          data: IconThemeData(
            size: textStyle?.fontSize != null
                ? (textStyle?.fontSize ?? 0) + 2
                : 20,
          ),
          child: trailing!,
        ),
      ],
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    final theme = Theme.of(context);

    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(
          width ?? 0,
          height ?? size.height,
        ),
      ),
      padding: WidgetStatePropertyAll(
        padding ??
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),
      ),
      backgroundColor: WidgetStatePropertyAll(
        _backgroundColor(context),
      ),
      foregroundColor: WidgetStatePropertyAll(
        _foregroundColor(context),
      ),
      side: WidgetStatePropertyAll(
        _borderSide(context),
      ),
      elevation: WidgetStatePropertyAll(
        variant == ButtonVariant.primary || variant == ButtonVariant.destructive
            ? 0
            : null,
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
      ),
      textStyle: WidgetStatePropertyAll(
        textStyle ??
            theme.textTheme.labelLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Color _backgroundColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    switch (variant) {
      case ButtonVariant.primary:
        return scheme.primary;
      case ButtonVariant.secondary:
        return Colors.transparent;
      case ButtonVariant.ghost:
        return Colors.transparent;
      case ButtonVariant.destructive:
        return scheme.error;
    }
  }

  Color _foregroundColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    switch (variant) {
      case ButtonVariant.primary:
        return scheme.onPrimary;
      case ButtonVariant.secondary:
        return scheme.primary;
      case ButtonVariant.ghost:
        return scheme.primary;
      case ButtonVariant.destructive:
        return scheme.onError;
    }
  }

  BorderSide? _borderSide(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    switch (variant) {
      case ButtonVariant.secondary:
        return BorderSide(
          color: scheme.outline,
        );
      default:
        return null;
    }
  }
}
