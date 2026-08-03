import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../domain/entity/entity.dart';
import '../provider/provider.dart';
import 'report_cluster_marker.dart';
import 'report_marker.dart';

/// The map surface itself: base tiles, clustered report markers, attribution.
///
/// Built once per page mount — only the marker layer subscribes to the
/// reports provider, so a refetch never rebuilds [FlutterMap] or its tiles.
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
        // Muted base tiles so the status colours stay dominant.
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.pantau.app',
        ),
        _ReportClusterLayer(onReportTap: onReportTap),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
      ],
    );
  }
}

/// Marker layer for the reports of the current camera. Reads the memoised
/// list so markers stay put across a pan refetch instead of blinking out.
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
        final reports = ref.watch(visibleReportsProvider);

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
