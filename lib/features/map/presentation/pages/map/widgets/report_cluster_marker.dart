import 'package:flutter/material.dart';

import '../../../../../../core/theme/theme.dart';

/// Bubble shown in place of overlapping markers, labelled with the count.
class ReportClusterMarker extends StatelessWidget {
  const ReportClusterMarker({super.key, required this.count});

  static const double size = 44;

  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$count reports',
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.accent,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.surfaceBase, width: 2),
          boxShadow: AppShadows.accentGlow(),
        ),
        child: Text(
          '$count',
          style: AppTypography.subheading.copyWith(
            fontSize: 14,
            color: AppColors.onAccent,
          ),
        ),
      ),
    );
  }
}
