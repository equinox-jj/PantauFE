/// Report/map API paths, relative to `ApiEndpoints.baseUrl`.
///
/// Kept in one place so a backend path change is a single-line edit.
abstract final class MapEndpoint {
  static const String nearbyReports = '/reports/nearby';
  static const String reportCategories = '/categories';
  static const String reports = '/reports';

  /// Detail path for a single report.
  static String reportDetail(String id) => '/reports/$id';
}
