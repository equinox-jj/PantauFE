import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/theme/theme.dart';

/// Label/value line used for category, coordinates and timestamps.
class ReportDetailRow extends StatelessWidget {
  const ReportDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isMono = false,
  });

  final IconData icon;
  final String label;
  final String value;

  /// Coordinates and other data values use the mono face.
  final bool isMono;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppIconSizes.md, color: AppColors.textMuted),
        const Gap(AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.label),
              const Gap(2),
              Text(
                value,
                style: isMono
                    ? AppTypography.mono(color: AppColors.textPrimary)
                    : AppTypography.body.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
