import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../core/theme/theme.dart';

/// Mini-map whose fixed centre pin marks where the report will be filed; the
/// user pans the map under the pin.
///
/// [center] and [isLocating] are listenables, not plain values: panning emits
/// a new centre every frame, and rebuilding [FlutterMap] that often would
/// thrash the tile layer. Only the readout and locate button listen.
class ReportLocationPicker extends StatelessWidget {
  const ReportLocationPicker({
    super.key,
    required this.controller,
    required this.initialCenter,
    required this.center,
    required this.onMoved,
    required this.onUseMyLocation,
    required this.isLocating,
  });

  final MapController controller;

  /// Camera the map opens on; later movement goes through [controller].
  final LatLng initialCenter;

  final ValueListenable<LatLng> center;
  final ValueChanged<LatLng> onMoved;
  final VoidCallback onUseMyLocation;
  final ValueListenable<bool> isLocating;

  /// Local: the spacing scale has no token sized for a map viewport.
  static const double _mapHeight = 200;

  /// Lifts the pin so its tip, not its bounding-box centre, lands on the map
  /// centre. 0.6 of [AppIconSizes.xl] (32px).
  static const double _pinTipOffset = 19.2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: AppRadius.radiusXl,
          child: SizedBox(
            height: _mapHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                FlutterMap(
                  mapController: controller,
                  options: MapOptions(
                    initialCenter: initialCenter,
                    initialZoom: 16,
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture) onMoved(position.center);
                    },
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.pantau.app',
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: _pinTipOffset),
                  child: Icon(
                    Icons.place,
                    size: AppIconSizes.xl,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(AppSpacing.xs2),
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<LatLng>(
                valueListenable: center,
                builder: (context, value, _) => Text(
                  '${value.latitude.toStringAsFixed(5)}, '
                  '${value.longitude.toStringAsFixed(5)}',
                  style: AppTypography.mono(color: AppColors.textPrimary),
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isLocating,
              builder: (context, locating, _) => TextButton.icon(
                onPressed: locating ? null : onUseMyLocation,
                icon: const Icon(Icons.my_location, size: AppIconSizes.md),
                label: const Text('Use my location'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
