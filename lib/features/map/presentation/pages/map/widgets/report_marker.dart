import 'package:flutter/material.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/extensions/extensions.dart';
import '../../../../domain/entity/entity.dart';

/// Status-coloured map pin for a single report. The icon repeats the status
/// so the marker still reads without colour, and the semantics label names it.
class ReportMarker extends StatelessWidget {
  const ReportMarker({super.key, required this.report, required this.onTap});

  static const double size = 44;

  final NearbyReport report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = report.status;

    return Semantics(
      button: true,
      label: '${report.category?.name ?? 'Report'}, ${status.label}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: status.color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surfaceBase, width: 2),
            boxShadow: AppShadows.floating,
          ),
          child: Icon(
            status.icon,
            size: AppIconSizes.md,
            color: status.inkColor,
          ),
        ),
      ),
    );
  }
}
