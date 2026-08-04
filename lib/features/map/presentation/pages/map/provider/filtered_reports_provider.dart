import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entity/entity.dart';
import 'map_category_filter.dart';
import 'visible_reports_provider.dart';

part 'filtered_reports_provider.g.dart';

/// The reports actually drawn on the map: [visibleReportsProvider] narrowed by
/// the selected category.
///
/// Filtering happens here, on the page already loaded, rather than as a query
/// parameter on `GET /reports/nearby` — chip switching is synchronous and
/// costs no refetch. The trade is that only the loaded page is filtered; see
/// the design doc's "Known constraint" section.
@riverpod
List<NearbyReport> filteredReports(Ref ref) {
  final reports = ref.watch(visibleReportsProvider);
  final categoryId = ref.watch(mapCategoryFilterProvider);

  // "All" returns the same instance rather than a copy, so an unfiltered map
  // allocates nothing per rebuild.
  if (categoryId == null) return reports;

  return reports
      .where((report) => report.category?.id == categoryId)
      .toList(growable: false);
}
