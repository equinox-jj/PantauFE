import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_category_filter.g.dart';

/// The category the map is filtered to, or `null` for "All" (FR-10).
///
/// Holds an id rather than a `ReportCategory`: the taxonomy can be refetched,
/// so a selection stored as an entity would go stale.
@riverpod
class MapCategoryFilter extends _$MapCategoryFilter {
  @override
  int? build() => null;

  void select(int? categoryId) => state = categoryId;

  /// Back to "All". Named for the empty state's action, not the value.
  void clear() => state = null;
}
