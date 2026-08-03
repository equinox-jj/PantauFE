import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/extensions/extensions.dart';

/// Status pill: colour + icon + label, never colour alone.
class ReportStatusChip extends StatelessWidget {
  const ReportStatusChip({super.key, required this.status});

  final ReportStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: AppRadius.radiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: AppIconSizes.sm, color: status.inkColor),
          const Gap(AppSpacing.xs2),
          Text(
            status.label,
            style: AppTypography.label.copyWith(
              fontWeight: FontWeight.w700,
              color: status.inkColor,
            ),
          ),
        ],
      ),
    );
  }
}
