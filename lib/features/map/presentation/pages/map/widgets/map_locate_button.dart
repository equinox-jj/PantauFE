import 'package:flutter/material.dart';

import '../../../../../../core/theme/theme.dart';

/// Recentres the map on the device position.
class MapLocateButton extends StatelessWidget {
  const MapLocateButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceFloat,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: AppShadows.floating,
      ),
      child: IconButton(
        tooltip: 'Use my location',
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: AppIconSizes.md,
                height: AppIconSizes.md,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.my_location, size: AppIconSizes.lg),
      ),
    );
  }
}
