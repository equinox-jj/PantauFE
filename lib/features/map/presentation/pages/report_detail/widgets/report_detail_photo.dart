import 'package:flutter/material.dart';

import '../../../../../../core/theme/theme.dart';

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
