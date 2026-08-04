import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../domain/entity/entity.dart';
import '../provider/provider.dart';
import 'map_pin_marker.dart';
import 'report_cluster_marker.dart';
import 'report_marker.dart';

/// Base tiles, clustered report markers, attribution.
///
/// Only the marker layer subscribes to the reports provider, so a refetch
/// never rebuilds [FlutterMap] or its tiles.
class MapCanvas extends StatelessWidget {
  const MapCanvas({
    super.key,
    required this.controller,
    required this.initialCenter,
    required this.initialZoom,
    required this.onMapEvent,
    required this.onReportTap,
  });

  final MapController controller;
  final LatLng initialCenter;
  final double initialZoom;
  final void Function(MapEvent event) onMapEvent;
  final ValueChanged<NearbyReport> onReportTap;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
        minZoom: 3,
        maxZoom: 18,
        onMapEvent: onMapEvent,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.pantau.app',
        ),
        // Below the markers: the ring is context, not a target, so its tint
        // never covers a report pin.
        const _LoadedAreaLayer(),
        _ReportClusterLayer(onReportTap: onReportTap),
        // Above the clusters: place pins must never be buried under a cluster
        // bubble. The searched pin sits last — it is what the user asked for.
        const _CurrentLocationLayer(),
        const _SearchedPlaceLayer(),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
      ],
    );
  }
}

/// [kNearbyRadiusInMeters] ring around the centre the reports were fetched for.
///
/// Follows the fetch rather than a pin: after "Search this area" the loaded
/// centre is the camera's, so a ring on the pin would promise coverage that
/// was never loaded.
class _LoadedAreaLayer extends StatelessWidget {
  const _LoadedAreaLayer();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final center = ref.watch(loadedAreaProvider);
        if (center == null) return const SizedBox.shrink();

        return CircleLayer(
          circles: [
            CircleMarker(
              point: center,
              radius: kNearbyRadiusInMeters.toDouble(),
              useRadiusInMeter: true,
              color: AppColors.teal400.withValues(alpha: 0.12),
              borderColor: AppColors.teal400.withValues(alpha: 0.55),
              borderStrokeWidth: 2,
            ),
          ],
        );
      },
    );
  }
}

/// Pin for the searched place. Its own layer so a reports refetch never
/// rebuilds it.
class _SearchedPlaceLayer extends StatelessWidget {
  const _SearchedPlaceLayer();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final place = ref.watch(searchedPlaceProvider);
        if (place == null) return const SizedBox.shrink();

        return MarkerLayer(
          markers: [
            _placePin(
              point: LatLng(place.latitude, place.longitude),
              child: MapPinMarker(label: 'Searched place: ${place.name}'),
            ),
          ],
        );
      },
    );
  }
}

/// Pin for the device position. Its own layer so a re-locate repaints the pin
/// alone.
class _CurrentLocationLayer extends StatelessWidget {
  const _CurrentLocationLayer();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final position = ref.watch(currentLocationProvider);
        if (position == null) return const SizedBox.shrink();

        return MarkerLayer(
          markers: [
            _placePin(
              point: position,
              child: const MapPinMarker(label: 'Your location'),
            ),
          ],
        );
      },
    );
  }
}

/// A [MapPinMarker] anchored so its tip, not its centre, sits on the
/// coordinate.
Marker _placePin({required LatLng point, required MapPinMarker child}) {
  return Marker(
    point: point,
    width: MapPinMarker.size,
    height: MapPinMarker.size,
    alignment: Alignment.topCenter,
    child: child,
  );
}

/// Marker layer for the current camera's reports. Reads the memoised,
/// category-filtered list so markers stay put across a pan refetch.
class _ReportClusterLayer extends StatelessWidget {
  const _ReportClusterLayer({required this.onReportTap});

  final ValueChanged<NearbyReport> onReportTap;

  List<Marker> _markersFrom(List<NearbyReport> reports) {
    return reports
        .where((r) => r.id != null && r.latitude != null && r.longitude != null)
        .map(
          (report) => Marker(
            point: LatLng(report.latitude!, report.longitude!),
            width: ReportMarker.size,
            height: ReportMarker.size,
            child: ReportMarker(
              report: report,
              onTap: () => onReportTap(report),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final reports = ref.watch(filteredReportsProvider);

        return MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 48,
            size: const Size(
              ReportClusterMarker.size,
              ReportClusterMarker.size,
            ),
            padding: const EdgeInsets.all(50),
            markers: _markersFrom(reports),
            builder: (context, markers) =>
                ReportClusterMarker(count: markers.length),
          ),
        );
      },
    );
  }
}
