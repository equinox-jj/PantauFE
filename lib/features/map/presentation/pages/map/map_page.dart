import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/service/service.dart';
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
///
/// Panning never fetches. Once the camera drifts away from what was last
/// loaded, a "Search this area" pill appears and the user decides whether the
/// request is worth making.
class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  /// Jakarta — fallback camera when the device position is unavailable.
  static const _fallbackCenter = LatLng(-6.2088, 106.8456);

  /// Chosen so the [kNearbyRadiusInMeters] ring fills most of the view: any
  /// wider and the corners show map the reports were never fetched for.
  static const _initialZoom = 14.5;
  static const _distance = Distance();

  /// How far the camera centre may drift from the last loaded centre, as a
  /// fraction of [kNearbyRadiusInMeters], before the results on screen stop
  /// describing what the user is looking at.
  static const _centreDriftFraction = 0.3;

  final MapController _mapController = MapController();

  /// Centre the reports on screen were loaded around. Null until the first
  /// load. No matching radius field — every fetch uses
  /// [kNearbyRadiusInMeters].
  LatLng? _loadedCenter;

  /// Visibility of the "Search this area" pill. A [ValueNotifier] rather than
  /// [setState] so toggling it repaints the pill alone, never the map.
  final ValueNotifier<bool> _canSearchArea = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapLocationProvider.notifier).locate();
    });
  }

  @override
  void dispose() {
    _canSearchArea.dispose();
    _mapController.dispose();
    super.dispose();
  }

  /// Whether the camera has walked far enough from the loaded centre that the
  /// reports on screen no longer describe what the user is looking at.
  ///
  /// Zoom is not part of this: the fetch radius is fixed, so a zoom-out shows
  /// ground outside the loaded circle but adds no reports to ask for — only
  /// moving the centre does.
  bool _cameraLeftLoadedArea(MapCamera camera) {
    final loadedCenter = _loadedCenter;
    // Nothing loaded yet (the startup fetch failed or never ran) — offering
    // the search is the only way back.
    if (loadedCenter == null) return true;

    final drift = _distance.as(LengthUnit.Meter, loadedCenter, camera.center);

    return drift > kNearbyRadiusInMeters * _centreDriftFraction;
  }

  void _handleMapEvent(MapEvent event) {
    final settled =
        event is MapEventMoveEnd ||
        event is MapEventFlingAnimationEnd ||
        event is MapEventDoubleTapZoomEnd;
    if (!settled) return;

    // The only thing a pan does: offer the fetch, never make it.
    _canSearchArea.value = _cameraLeftLoadedArea(_mapController.camera);
  }

  /// Fetches reports for [camera]'s centre. Shared by the "Search this area"
  /// pill and the error state's retry action so both stay in sync.
  void _loadReportsForCamera(MapCamera camera) =>
      _loadReportsAround(camera.center);

  /// Loads the reports within [kNearbyRadiusInMeters] of [center] and retires
  /// the pill — the reports arriving are the ones for this view.
  void _loadReportsAround(LatLng center) {
    _loadedCenter = center;
    _canSearchArea.value = false;
    // Moves the ring with the fetch, so it never marks ground the reports on
    // screen were not loaded for.
    ref.read(loadedAreaProvider.notifier).update(center);

    ref
        .read(nearbyReportsProvider.notifier)
        .load(
          latitude: center.latitude,
          longitude: center.longitude,
          radiusInMeters: kNearbyRadiusInMeters,
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
    ref.read(currentLocationProvider.notifier).update(center);
    _mapController.move(center, _initialZoom);
    _loadReportsAround(center);
  }

  /// Runs a place search biased toward what the user is currently looking at,
  /// so "Gambir" resolves to the one on screen before the one three provinces
  /// away.
  void _searchPlaces(String query) {
    final bounds = _mapController.camera.visibleBounds;

    ref
        .read(placeSearchProvider.notifier)
        .search(
          query,
          viewBox: PlaceViewBox(
            minLatitude: bounds.south,
            minLongitude: bounds.west,
            maxLatitude: bounds.north,
            maxLongitude: bounds.east,
          ),
        );
  }

  /// Clears both halves of the search: the results panel and the pin.
  void _clearSearch() {
    ref.read(placeSearchProvider.notifier).clear();
    ref.read(searchedPlaceProvider.notifier).clear();
  }

  /// Moves the camera to [place], marks it, and loads the reports around it.
  void _handlePlaceSelected(Place place) {
    FocusScope.of(context).unfocus();

    final center = LatLng(place.latitude, place.longitude);
    ref.read(searchedPlaceProvider.notifier).select(place);
    // Close the panel but keep the pin — the field still shows the query.
    ref.read(placeSearchProvider.notifier).clear();

    _mapController.move(center, _initialZoom);
    _loadReportsAround(center);
  }

  void _searchThisArea() => _loadReportsForCamera(_mapController.camera);

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
            // Both sit below the top bar in paint order: their offset is
            // measured against the collapsed bar, so an open results panel —
            // which is taller — must cover them rather than be covered.
            _SearchAreaControl(
              topOffset: MediaQuery.paddingOf(context).top + MapTopBar.height,
              canSearch: _canSearchArea,
              onPressed: _searchThisArea,
            ),
            _ReportsLoadingIndicator(
              topOffset: MediaQuery.paddingOf(context).top + MapTopBar.height,
            ),
            MapTopBar(
              onSearchSubmitted: _searchPlaces,
              onSearchCleared: _clearSearch,
              onPlaceSelected: _handlePlaceSelected,
            ),
            _BottomStack(
              onStartReport: _startReport,
              onRetry: () => _loadReportsForCamera(_mapController.camera),
            ),
            // Last layer: a map without a position cannot locate or pin, so
            // the permission cover hides the controls along with the map.
            const MapPermissionOverlay(),
          ],
        ),
      ),
    );
  }
}

/// The bottom of the map: locate button, report FAB, and the status sheet
/// under them.
///
/// A column rather than three positioned layers so the controls ride on top
/// of the sheet — when it appears they lift by exactly its height, with no
/// offset constant to keep in sync.
class _BottomStack extends StatelessWidget {
  const _BottomStack({required this.onStartReport, required this.onRetry});

  final VoidCallback onStartReport;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const _LocateControl(),
                const Gap(AppSpacing.md),
                MapReportFab(onPressed: onStartReport),
              ],
            ),
          ),
          // Doubles as the controls' clearance from the bottom edge while the
          // sheet is collapsed.
          const Gap(AppSpacing.md),
          MapStatusSheet(onRetry: onRetry),
        ],
      ),
    );
  }
}

/// The "Search this area" pill, shown only once the camera has left the area
/// the current markers were loaded for.
///
/// Shares the slot under the top bar with [_ReportsLoadingIndicator]: tapping
/// the pill hides it and starts the fetch the spinner then reports on, so the
/// two are never on screen together.
class _SearchAreaControl extends StatelessWidget {
  const _SearchAreaControl({
    required this.topOffset,
    required this.canSearch,
    required this.onPressed,
  });

  /// Clearance from the top so the pill sits below the filter chips instead
  /// of behind them.
  final double topOffset;

  final ValueListenable<bool> canSearch;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: canSearch,
      builder: (context, canSearch, child) {
        if (!canSearch) return const SizedBox.shrink();

        return Positioned(top: topOffset, left: 0, right: 0, child: child!);
      },
      child: Center(child: MapSearchAreaButton(onPressed: onPressed)),
    );
  }
}

/// Thin progress bar for an in-flight refetch, shown over the map while the
/// previous markers stay visible.
class _ReportsLoadingIndicator extends StatelessWidget {
  const _ReportsLoadingIndicator({required this.topOffset});

  /// Clearance from the top so the spinner sits below the filter chips
  /// instead of behind them.
  final double topOffset;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isLoading = ref.watch(
          nearbyReportsProvider.select((state) => state.isLoading),
        );
        if (!isLoading) return const SizedBox.shrink();

        return Positioned(top: topOffset, left: 0, right: 0, child: child!);
      },
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

/// Recentre button, spinning only while a location request is in flight.
class _LocateControl extends StatelessWidget {
  const _LocateControl();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isLocating = ref.watch(
          mapLocationProvider.select((state) => state.isLoading),
        );

        return MapLocateButton(
          isLoading: isLocating,
          onPressed: () => ref.read(mapLocationProvider.notifier).locate(),
        );
      },
    );
  }
}
