import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../di/di.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/usecase/usecase.dart';

part 'nearby_reports_notifier.g.dart';

/// Ground radius of every nearby-reports fetch, and of the ring drawn on the
/// map.
///
/// Fixed rather than derived from the camera: the ring promises which reports
/// are loaded, so the two must be the same number.
const int kNearbyRadiusInMeters = 1000;

/// Nearby reports for the current map camera. Holding the previous markers
/// during a pan refetch is `visibleReportsProvider`'s job, not this one's.
@riverpod
class NearbyReports extends _$NearbyReports {
  /// Camera used by the most recent [load] call, replayed by [refresh].
  double? _latitude;
  double? _longitude;
  int? _radiusInMeters;

  /// Guards against out-of-order responses: a superseded request must not
  /// overwrite a newer one's state.
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
    // A newer load() owns the state now — drop this stale result.
    if (requestId != _requestId) return;

    result.fold(
      (l) => state = AsyncError<List<NearbyReport>>(l, StackTrace.current),
      (r) => state = AsyncData(r),
    );
  }

  /// Replays the last camera so a mutation elsewhere can refresh the list
  /// without wiping it via `invalidate`. No-op if [load] never ran.
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
