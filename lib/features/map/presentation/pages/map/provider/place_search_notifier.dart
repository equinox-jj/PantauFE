import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../di/di.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/usecase/usecase.dart';

part 'place_search_notifier.g.dart';

/// Results of the place-search field above the map.
///
/// Runs on submit only, never per keystroke: public Nominatim asks callers not
/// to drive autocomplete off `/search`, and one request per submit stays
/// inside its 1 request/second policy.
@riverpod
class PlaceSearch extends _$PlaceSearch {
  /// Query of the most recent [search], replayed by [retry].
  String? _query;
  PlaceViewBox? _viewBox;

  /// Guards against out-of-order responses: a superseded request must not
  /// overwrite a newer one's state.
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
    // A newer search owns the state now — drop this stale result.
    if (requestId != _requestId) return;

    result.fold(
      (l) => state = AsyncError<List<Place>>(l, StackTrace.current),
      (r) => state = AsyncData(r),
    );
  }

  /// Replays the last query. No-op if [search] never ran.
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
