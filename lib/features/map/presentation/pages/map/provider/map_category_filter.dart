import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_category_filter.g.dart';

/// The category the map is filtered to, or `null` for "All" (FR-10).
///
/// Deliberately holds an id rather than a `ReportCategory`: the taxonomy is
/// fetched asynchronously and can be refetched, so a selection stored as an
/// entity would go stale against a newer list.
@riverpod
class MapCategoryFilter extends _$MapCategoryFilter {
  @override
  int? build() => null;

  void select(int? categoryId) => state = categoryId;

  /// Back to "All". Same effect as `select(null)`; named for what the empty
  /// state's action means rather than for the value it passes.
  void clear() => state = null;
}
