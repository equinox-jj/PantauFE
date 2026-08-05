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

/// Primary action of the map tab: start a new report.
class MapReportFab extends StatelessWidget {
  const MapReportFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.add_a_photo_outlined),
      label: const Text('Report'),
    );
  }
}

/// Manual refetch trigger for the camera the user has panned to.
///
/// The map never fetches on its own; this pill is the only way a camera move
/// turns into a request.
class MapSearchAreaButton extends StatelessWidget {
  const MapSearchAreaButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  static const _height = 38.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      // Opaque so the map never shows through the pill.
      color: Color.alphaBlend(AppColors.fillAccent, AppColors.surfaceFloat),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusFull,
        side: BorderSide(color: AppColors.borderAccent),
      ),
      shadowColor: Colors.black,
      elevation: 4,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: _height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.search,
                  size: AppIconSizes.sm,
                  color: AppColors.teal400,
                ),
                const SizedBox(width: AppSpacing.xs2 / 2),
                Text(
                  'Search this area',
                  style: AppTypography.body.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.teal400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
