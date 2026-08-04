import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/components/button/button.dart';
import '../../../../../../core/components/empty_state/empty_state.dart';
import '../../../../../../core/service/service.dart';
import '../../../../../../core/theme/theme.dart';
import '../provider/provider.dart';
import 'map_permission_state.dart';

/// Copy and recovery action for a permission-related map overlay.
typedef _PermissionOverlay = ({
  String title,
  String message,
  String actionText,
  VoidCallback onAction,
});

/// The overlays stacked on the map: permission recovery, load failure, and
/// the empty-area state. Owns its own subscriptions so a location or reports
/// change repaints this layer alone, never the map underneath it.
class MapStatusOverlay extends StatelessWidget {
  const MapStatusOverlay({
    super.key,
    required this.bottomOffset,
    required this.onRetry,
  });

  /// Clearance from the bottom so the overlays sit above the report FAB
  /// instead of behind it.
  final double bottomOffset;

  final VoidCallback onRetry;

  /// Copy and recovery action for the map's permission-related overlay.
  /// Every non-success [LocationResult] is a designed state, not a silent
  /// fallback to the Jakarta camera with a passing snackbar.
  _PermissionOverlay? _permissionOverlayFor(
    WidgetRef ref,
    LocationResult? result,
  ) {
    return switch (result) {
      LocationPermissionDeniedForever() => (
        title: 'Location is switched off',
        message:
            'Pantau shows reports around you and pins new ones where you '
            'are. Enable location access to continue.',
        actionText: 'Open settings',
        onAction: () => ref.read(mapLocationProvider.notifier).openSettings(),
      ),
      LocationPermissionDenied() => (
        title: 'Location permission needed',
        message:
            'Pantau needs your location to show reports around you and pin '
            'new ones where you are.',
        actionText: 'Try again',
        onAction: () => ref.read(mapLocationProvider.notifier).locate(),
      ),
      LocationServiceDisabled() => (
        title: 'Location services are off',
        message:
            'Turn on location services in your device settings to see '
            'reports around you.',
        actionText: 'Try again',
        onAction: () => ref.read(mapLocationProvider.notifier).locate(),
      ),
      LocationSuccess() || LocationFailed() || null => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final locationResult = ref.watch(
          mapLocationProvider.select((state) => state.value),
        );
        final permissionOverlay = _permissionOverlayFor(ref, locationResult);

        if (permissionOverlay != null) {
          return Positioned.fill(
            child: ColoredBox(
              color: AppColors.surfaceBase.withValues(alpha: 0.92),
              child: MapPermissionState(
                title: permissionOverlay.title,
                message: permissionOverlay.message,
                actionText: permissionOverlay.actionText,
                onAction: permissionOverlay.onAction,
              ),
            ),
          );
        }

        final reports = ref.watch(visibleReportsProvider);
        if (reports.isNotEmpty) return const SizedBox.shrink();

        final reportsState = ref.watch(nearbyReportsProvider);

        if (reportsState.hasError) {
          return Positioned(
            left: 0,
            right: 0,
            bottom: bottomOffset,
            child: AppEmptyState(
              icon: Icons.cloud_off,
              title: 'Could not load reports',
              message:
                  'Something went wrong loading reports for this area. '
                  'Check your connection and try again.',
              action: AppButton(
                text: 'Try again',
                fullWidth: false,
                onPressed: onRetry,
              ),
            ),
          );
        }

        if (!reportsState.isLoading) {
          return Positioned(
            left: 0,
            right: 0,
            bottom: bottomOffset,
            child: const AppEmptyState(
              icon: Icons.map_outlined,
              title: 'No reports nearby',
              message:
                  'Nothing has been reported in this area yet. Pan the '
                  'map or be the first to report something.',
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
