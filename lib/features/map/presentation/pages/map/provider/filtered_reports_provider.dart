import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entity/entity.dart';
import 'map_category_filter.dart';
import 'visible_reports_provider.dart';

part 'filtered_reports_provider.g.dart';

/// The reports drawn on the map: [visibleReportsProvider] narrowed by the
/// selected category.
///
/// Filtered client-side rather than through `GET /reports/nearby`, so chip
/// switching is synchronous and costs no refetch. The trade is that only the
/// loaded page is filtered; see the design doc's "Known constraint".
@riverpod
List<NearbyReport> filteredReports(Ref ref) {
  final reports = ref.watch(visibleReportsProvider);
  final categoryId = ref.watch(mapCategoryFilterProvider);

  // Same instance, not a copy — an unfiltered map allocates nothing.
  if (categoryId == null) return reports;

  return reports
      .where((report) => report.category?.id == categoryId)
      .toList(growable: false);
}
