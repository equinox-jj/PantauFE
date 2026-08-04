import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../di/di.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/usecase/usecase.dart';

part 'place_search_notifier.g.dart';

/// Results of the place-search field above the map.
///
/// A search runs on submit only, never per keystroke: the public Nominatim
/// instance asks callers not to drive autocomplete off `/search`, and one
/// request per submit stays inside its 1 request/second policy.
@riverpod
class PlaceSearch extends _$PlaceSearch {
  /// Query of the most recent [search], replayed by [retry].
  String? _query;
  PlaceViewBox? _viewBox;

  /// Monotonically increasing id guarding against out-of-order responses:
  /// a slow, superseded request must not overwrite a newer one's state.
  int _requestId = 0;

  /// `null` means the panel is closed — distinct from `AsyncData([])`, which
  /// means "searched, found nothing".
  @override
  AsyncValue<List<Place>>? build() => null;

  Future<void> search(String query, {PlaceViewBox? viewBox}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      clear();
      return;
    }

    _query = trimmed;
    _viewBox = viewBox;

    final requestId = ++_requestId;
    state = const AsyncLoading<List<Place>>();

    final usecase = ref.read(searchPlacesUsecaseProvider);
    final result = await usecase(
      SearchPlacesParams(query: trimmed, viewBox: viewBox),
    );
    if (!ref.mounted) return;
    // A newer search started while this one was in flight — its result owns
    // the state now, so this stale one is dropped.
    if (requestId != _requestId) return;

    result.fold(
      (l) => state = AsyncError<List<Place>>(l, StackTrace.current),
      (r) => state = AsyncData(r),
    );
  }

  /// Replays the last query. A safe no-op if [search] has never succeeded in
  /// starting.
  Future<void> retry() {
    final query = _query;
    if (query == null) return Future<void>.value();

    return search(query, viewBox: _viewBox);
  }

  /// Closes the results panel. Any in-flight request is orphaned by the id
  /// bump, so a late response cannot reopen it.
  void clear() {
    _requestId++;
    _query = null;
    _viewBox = null;
    state = null;
  }
}
