import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  /// Returns the current [ThemeData] for this [BuildContext].
  ThemeData get theme => Theme.of(this);

  /// Returns the current [TextTheme] for this [BuildContext].
  TextTheme get textTheme => TextTheme.of(this);

  /// Returns the current [ColorScheme] for this [BuildContext].
  ColorScheme get colorScheme => ColorScheme.of(this);

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
}
