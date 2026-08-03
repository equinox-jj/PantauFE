import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/error/error.dart';
import '../../../../../../core/location/location.dart';
import '../../../../../../core/theme/theme.dart';
import '../provider/provider.dart';

/// Side effects of the map tab: a snackbar when a fetch fails, a dialog
/// explaining why location is needed when permission is refused, and the
/// camera/fetch handoff once a location attempt settles.
class MapListener extends ConsumerWidget {
  const MapListener({super.key, required this.onLocated, required this.child});

  /// Called with every settled [LocationResult] — including the failure
  /// cases, which the page turns into a fallback camera and fetch.
  final ValueChanged<LocationResult> onLocated;

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(nearbyReportsProvider, (previous, next) {
      if (next case AsyncError(error: final error)) {
        final message = error is Failure
            ? error.displayMessage
            : error.toString();

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              backgroundColor: AppColors.statusRejected,
              content: Text(message),
            ),
          );
      }
    });

    ref.listen(mapLocationProvider, (previous, next) {
      if (next case AsyncData(value: final result?)) {
        onLocated(result);

        switch (result) {
          case LocationSuccess():
            break;
          case LocationServiceDisabled():
            _showMessage(
              context,
              'Location services are switched off. Turn them on to see '
              'reports around you.',
            );
          case LocationPermissionDenied():
            _showMessage(
              context,
              'Pantau needs your location to show nearby reports.',
            );
          case LocationPermissionDeniedForever():
            _showSettingsDialog(context, ref);
          case LocationFailed():
            _showMessage(context, LocationFailed.message);
        }
      }
    });

    return child;
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSettingsDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Location permission needed'),
        content: const Text(
          'Pantau shows reports around you and pins new ones where you are. '
          'Enable location access in Settings to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Not now'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(mapLocationProvider.notifier).openSettings();
            },
            child: const Text('Open settings'),
          ),
        ],
      ),
    );
  }
}
