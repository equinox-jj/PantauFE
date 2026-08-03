import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../di/di.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/usecase/usecase.dart';

part 'nearby_reports_notifier.g.dart';

/// Nearby reports for the current map camera. Keeping the previous markers
/// on screen while a pan refetch is in flight is not this notifier's job —
/// `visibleReportsProvider` memoises the last loaded list for that.
@riverpod
class NearbyReports extends _$NearbyReports {
  /// Camera used by the most recent [load] call, replayed by [refresh].
  double? _latitude;
  double? _longitude;
  int? _radiusInMeters;

  /// Monotonically increasing id guarding against out-of-order responses:
  /// a slow, superseded request must not overwrite a newer one's state.
  int _requestId = 0;

  @override
  AsyncValue<List<NearbyReport>> build() => const AsyncData([]);

  Future<void> load({
    required double latitude,
    required double longitude,
    required int radiusInMeters,
  }) async {
    _latitude = latitude;
    _longitude = longitude;
    _radiusInMeters = radiusInMeters;

    final requestId = ++_requestId;
    state = const AsyncLoading<List<NearbyReport>>();

    final usecase = ref.read(getNearbyReportsUsecaseProvider);
    final params = GetNearbyReportsParams(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: radiusInMeters,
    );
    final result = await usecase(params);
    if (!ref.mounted) return;
    // A newer load() started while this one was in flight — its result
    // (whichever arrives) owns the state now, so this stale one is dropped.
    if (requestId != _requestId) return;

    result.fold(
      (l) => state = AsyncError<List<NearbyReport>>(l, StackTrace.current),
      (r) => state = AsyncData(r),
    );
  }

  /// Replays the last-used camera so a mutation elsewhere (e.g. submitting a
  /// report) can refresh the list without wiping it via `invalidate`. A safe
  /// no-op if [load] has never been called.
  Future<void> refresh() {
    final latitude = _latitude;
    final longitude = _longitude;
    final radiusInMeters = _radiusInMeters;
    if (latitude == null || longitude == null || radiusInMeters == null) {
      return Future<void>.value();
    }

    return load(
      latitude: latitude,
      longitude: longitude,
      radiusInMeters: radiusInMeters,
    );
  }
}
