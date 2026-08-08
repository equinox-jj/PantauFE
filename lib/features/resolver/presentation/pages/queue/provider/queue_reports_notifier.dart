import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/utils/enums/enums.dart';
import '../../../../di/resolver_di.dart';
import '../../../../domain/entity/resolver_entity.dart';
import '../../../../domain/usecase/resolver_usecase.dart';

part 'queue_reports_notifier.g.dart';

/// Ground radius of every queue fetch. Matches the API's own default.
const int kQueueRadiusInMeters = 5000;

/// Page size — the queue pages through `offset` rather than fetching
/// everything at once, unlike the citizen feed.
const int kQueueLimit = 20;

/// One page (or accumulated pages) of the queue: the rows shown so far, the
/// tab counts from the most recent response, whether another page follows,
/// and whether a [QueueReports.loadMore] call is currently in flight.
class QueueListState {
  const QueueListState({
    required this.items,
    required this.counts,
    required this.hasNext,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  final List<QueueReport> items;
  final QueueCounts counts;
  final bool hasNext;
  final bool isLoadingMore;

  /// Set when the most recent [QueueReports.loadMore] page failed. Cleared
  /// as soon as another [QueueReports.loadMore] attempt starts.
  final bool loadMoreFailed;

  QueueListState copyWith({
    List<QueueReport>? items,
    QueueCounts? counts,
    bool? hasNext,
    bool? isLoadingMore,
    bool? loadMoreFailed,
  }) {
    return QueueListState(
      items: items ?? this.items,
      counts: counts ?? this.counts,
      hasNext: hasNext ?? this.hasNext,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
    );
  }
}

/// The active tab's queue, newest fetch wins.
///
/// Switching tabs calls [load] again rather than keeping three lists cached
/// — every response already carries fresh counts for all three tabs, so the
/// tab counts stay in sync across switches even though the list itself
/// refetches. Three parallel cached lists would be unnecessary complexity
/// for a first version.
@riverpod
class QueueReports extends _$QueueReports {
  QueueTab? _tab;
  double? _latitude;
  double? _longitude;
  int _offset = 0;

  /// Guards against out-of-order responses: a superseded request must not
  /// overwrite a newer one's state.
  int _requestId = 0;

  /// True while a [load] is in flight. Lets [loadMore] no-op instead of
  /// racing a concurrent [load] (e.g. a tab switch) — see [loadMore].
  bool _isLoading = false;

  /// Starts loading rather than empty: the page locates on mount, so an
  /// empty list before the first response would render as "nothing here".
  @override
  AsyncValue<QueueListState> build() => const AsyncLoading();

  Future<void> load({
    required QueueTab tab,
    required double latitude,
    required double longitude,
  }) async {
    _tab = tab;
    _latitude = latitude;
    _longitude = longitude;
    _offset = 0;
    _isLoading = true;

    final requestId = ++_requestId;
    // Only a load with nothing on screen announces itself. A refetch (or a
    // tab switch) keeps the previous cards until the new page lands.
    if (!state.hasValue) state = const AsyncLoading<QueueListState>();

    final usecase = ref.read(getQueueUsecaseProvider);
    final result = await usecase(
      GetQueueParams(
        tab: tab,
        latitude: latitude,
        longitude: longitude,
        radiusMeter: kQueueRadiusInMeters,
        limit: kQueueLimit,
        offset: 0,
      ),
    );
    if (!ref.mounted) return;
    // A newer load() owns the state now — drop this stale result. Leave
    // _isLoading alone: the newer load() already set it true again.
    if (requestId != _requestId) return;
    _isLoading = false;

    result.fold(
      (l) => state = AsyncError<QueueListState>(l, StackTrace.current),
      (r) => state = AsyncData(
        QueueListState(items: r.items, counts: r.counts, hasNext: r.hasNext),
      ),
    );
  }

  /// Fetches the next page and appends it. No-op if there is nothing more, a
  /// page is already in flight, or [load] has not run yet.
  Future<void> loadMore() async {
    final tab = _tab;
    final latitude = _latitude;
    final longitude = _longitude;
    final current = state.value;
    if (tab == null || latitude == null || longitude == null) return;
    if (current == null || !current.hasNext || current.isLoadingMore) return;
    // A load() (e.g. a tab switch) is in flight: current still holds the
    // previous tab's items, so paginating now would splice the two tabs'
    // pages together. Bail and let the in-flight load() land instead.
    if (_isLoading) return;

    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreFailed: false),
    );

    final requestId = ++_requestId;
    final nextOffset = _offset + kQueueLimit;
    final usecase = ref.read(getQueueUsecaseProvider);
    final result = await usecase(
      GetQueueParams(
        tab: tab,
        latitude: latitude,
        longitude: longitude,
        radiusMeter: kQueueRadiusInMeters,
        limit: kQueueLimit,
        offset: nextOffset,
      ),
    );
    if (!ref.mounted) return;
    if (requestId != _requestId) return;

    result.fold(
      // A failed page keeps the rows already shown; only the spinner clears,
      // replaced by a retry affordance.
      (l) => state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreFailed: true),
      ),
      (r) {
        _offset = nextOffset;
        state = AsyncData(
          QueueListState(
            items: [...current.items, ...r.items],
            counts: r.counts,
            hasNext: r.hasNext,
          ),
        );
      },
    );
  }

  /// Replays the last (tab, position) from the first page. No-op if [load]
  /// never ran.
  Future<void> refresh() {
    final tab = _tab;
    final latitude = _latitude;
    final longitude = _longitude;
    if (tab == null || latitude == null || longitude == null) {
      return Future<void>.value();
    }

    return load(tab: tab, latitude: latitude, longitude: longitude);
  }
}
