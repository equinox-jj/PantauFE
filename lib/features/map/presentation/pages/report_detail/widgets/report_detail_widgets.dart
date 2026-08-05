import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/theme/theme.dart';

/// The reporter's photo, with its own loading and error fallbacks. Fills the
/// box it is given; the hero owns the sizing and the clipping.
class ReportDetailPhoto extends StatelessWidget {
  const ReportDetailPhoto({super.key, required this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;
    if (url == null || url.isEmpty) {
      return const _PhotoFallback(label: 'No photo attached');
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const ColoredBox(
              color: AppColors.surfaceRaised,
              child: Center(child: CircularProgressIndicator()),
            ),
      errorBuilder: (context, error, stackTrace) =>
          const _PhotoFallback(label: 'Photo unavailable'),
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
