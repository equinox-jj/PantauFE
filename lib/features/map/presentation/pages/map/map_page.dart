import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/location/location.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../core/theme/theme.dart';
import '../../../domain/entity/entity.dart';
import '../report_detail/report_detail.dart';
import 'listener/listener.dart';
import 'provider/provider.dart';
import 'widgets/widgets.dart';

/// Home tab — nearby reports on an OSM map with clustered markers.
///
/// The page owns the camera and the fetch triggers only; every provider read
/// that drives pixels lives in a [Consumer] below, so a reports refetch or a
/// location change repaints one layer instead of the whole stack.
class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  /// Jakarta — fallback camera when the device position is unavailable.
  static const _fallbackCenter = LatLng(-6.2088, 106.8456);
  static const _initialZoom = 14.0;
  static const _initialRadiusInMeters = 3000;
  static const _minRadiusInMeters = 500;
  static const _maxRadiusInMeters = 20000;
  static const _refetchDebounce = Duration(milliseconds: 600);
  static const _distance = Distance();

  /// Clearance from the bottom so the empty/error overlays and the locate
  /// button sit above the report FAB instead of behind it.
  static const _bottomOverlayOffset = 140.0;

  final MapController _mapController = MapController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapLocationProvider.notifier).locate();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  /// Radius covering the visible camera, clamped so a zoomed-out map cannot
  /// ask the server for a country-scale query.
  int _radiusForCamera(MapCamera camera) {
    final bounds = camera.visibleBounds;
    final meters = _distance.as(
      LengthUnit.Meter,
      bounds.center,
      bounds.northEast,
    );

    return meters.clamp(_minRadiusInMeters, _maxRadiusInMeters).round();
  }

  void _handleMapEvent(MapEvent event) {
    final settled =
        event is MapEventMoveEnd ||
        event is MapEventFlingAnimationEnd ||
        event is MapEventDoubleTapZoomEnd;
    if (!settled) return;

    _debounce?.cancel();
    _debounce = Timer(_refetchDebounce, () {
      _loadReportsForCamera(_mapController.camera);
    });
  }

  /// Fetches reports for [camera]'s centre and visible radius. Shared by the
  /// pan-debounce refetch and the error state's retry action so both stay
  /// in sync.
  void _loadReportsForCamera(MapCamera camera) {
    ref
        .read(nearbyReportsProvider.notifier)
        .load(
          latitude: camera.center.latitude,
          longitude: camera.center.longitude,
          radiusInMeters: _radiusForCamera(camera),
        );
  }

  /// Loads the first page of reports around [center] at the initial zoom's
  /// radius. Only the startup/locate path uses this; pan refetches derive
  /// their radius from the live camera instead.
  void _loadReportsAround(LatLng center) {
    ref
        .read(nearbyReportsProvider.notifier)
        .load(
          latitude: center.latitude,
          longitude: center.longitude,
          radiusInMeters: _initialRadiusInMeters,
        );
  }

  void _handleLocated(LocationResult result) {
    // The device position is unavailable (denied, services off, or failed) —
    // fall back to the Jakarta camera so the map still has reports to show.
    // Deliberately the only other fetch trigger at startup: fetching the
    // fallback up front would double-hit the API on every cold open.
    if (result is! LocationSuccess) {
      _loadReportsAround(_fallbackCenter);
      return;
    }

    final center = LatLng(result.latitude, result.longitude);
    _mapController.move(center, _initialZoom);
    _loadReportsAround(center);
  }

  void _openReport(NearbyReport report) {
    final id = report.id;
    if (id == null) return;

    ReportDetailSheet.show(context, reportId: id);
  }

  void _startReport() => context.push(AppRoutes.createReport);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapListener(
        onLocated: _handleLocated,
        child: Stack(
          children: [
            MapCanvas(
              controller: _mapController,
              initialCenter: _fallbackCenter,
              initialZoom: _initialZoom,
              onMapEvent: _handleMapEvent,
              onReportTap: _openReport,
            ),
            const _ReportsLoadingIndicator(),
            MapStatusOverlay(
              bottomOffset: _bottomOverlayOffset,
              onRetry: () => _loadReportsForCamera(_mapController.camera),
            ),
            const _LocateControl(bottomOffset: _bottomOverlayOffset),
          ],
        ),
      ),
      floatingActionButton: MapReportFab(onPressed: _startReport),
    );
  }
}

/// Thin progress bar for an in-flight refetch, shown over the map while the
/// previous markers stay visible.
class _ReportsLoadingIndicator extends StatelessWidget {
  const _ReportsLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isLoading = ref.watch(
          nearbyReportsProvider.select((state) => state.isLoading),
        );
        if (!isLoading) return const SizedBox.shrink();

        return child!;
      },
      child: const Positioned(
        top: AppSpacing.md,
        left: 0,
        right: 0,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}

/// Recentre button, spinning only while a location request is in flight.
class _LocateControl extends StatelessWidget {
  const _LocateControl({required this.bottomOffset});

  final double bottomOffset;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isLocating = ref.watch(
          mapLocationProvider.select((state) => state.isLoading),
        );

        return Positioned(
          right: AppSpacing.md,
          bottom: bottomOffset,
          child: MapLocateButton(
            isLoading: isLocating,
            onPressed: () => ref.read(mapLocationProvider.notifier).locate(),
          ),
        );
      },
    );
  }
}
