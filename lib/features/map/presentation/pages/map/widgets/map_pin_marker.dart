import 'package:flutter/material.dart';

import '../../../../../../core/theme/theme.dart';

/// Teardrop pin for the map's two singular places: where the user is and where
/// they searched.
///
/// Not a circle — report markers are status-coloured circles, so shape alone
/// tells a place apart from a report. The two pins share the accent colour and
/// differ only by position and the semantics [label].
class MapPinMarker extends StatelessWidget {
  const MapPinMarker({super.key, required this.label});

  /// Spoken description of what the pin marks.
  final String label;

  static const double size = 44;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: const Icon(
        Icons.place,
        size: size,
        color: AppColors.teal400,
        shadows: AppShadows.floating,
      ),
    );
  }
}
