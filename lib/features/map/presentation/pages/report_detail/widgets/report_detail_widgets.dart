import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../../core/utils/extensions/extensions.dart';

/// The reporter's photo, with its own loading and error fallbacks.
class ReportDetailPhoto extends StatelessWidget {
  const ReportDetailPhoto({super.key, required this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;

    return ClipRRect(
      borderRadius: AppRadius.radiusXl,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: url == null || url.isEmpty
            ? const _PhotoFallback(label: 'No photo attached')
            : Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const ColoredBox(
                        color: AppColors.surfaceRaised,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                errorBuilder: (context, error, stackTrace) =>
                    const _PhotoFallback(label: 'Photo unavailable'),
              ),
      ),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceRaised,
      child: Center(child: Text(label, style: AppTypography.body)),
    );
  }
}

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
