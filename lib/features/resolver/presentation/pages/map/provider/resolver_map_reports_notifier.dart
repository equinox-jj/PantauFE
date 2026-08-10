import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/utils/enums/enums.dart';
import '../../../../di/resolver_di.dart';
import '../../../../domain/entity/resolver_entity.dart';
import '../../../../domain/usecase/resolver_usecase.dart';

part 'resolver_map_reports_notifier.g.dart';

/// Single-page cap for the map. There is no scroll position to page
/// against and no "load more" affordance a marker layer could show, so it
/// fetches one larger page instead of paginating the way the Queue does.
/// Matches `kQueueRadiusInMeters` (`queue_reports_notifier.dart`) for the
/// search radius — same API default, not redefined here to avoid a
/// cross-page-folder import for a single shared literal.
const int kResolverMapLimit = 50;
const int kResolverMapRadiusInMeters = 5000;

/// Reports plotted on the map for the active tab. One-shot fetch, no
/// pagination — re-locating or switching tabs is the only refresh trigger.
@riverpod
class ResolverMapReports extends _$ResolverMapReports {
  int _requestId = 0;

  @override
  AsyncValue<QueueResult> build() => const AsyncLoading();

  Future<void> load({
    required QueueTab tab,
    required double latitude,
    required double longitude,
  }) async {
    final requestId = ++_requestId;
    if (!state.hasValue) state = const AsyncLoading<QueueResult>();

    final usecase = ref.read(getQueueUsecaseProvider);
    final result = await usecase(
      GetQueueParams(
        tab: tab,
        latitude: latitude,
        longitude: longitude,
        radiusMeter: kResolverMapRadiusInMeters,
        limit: kResolverMapLimit,
        offset: 0,
      ),
    );
    if (!ref.mounted) return;
    if (requestId != _requestId) return;

    result.fold(
      (l) => state = AsyncError<QueueResult>(l, StackTrace.current),
      (r) => state = AsyncData(r),
    );
  }
}
