/// Report/map API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class MapEndpoint {
  static const String nearbyReports = '/reports/nearby';
  static const String reportCategories = '/categories';
  static const String reports = '/reports';

  static String reportDetail(String id) => '/reports/$id';

  static String reportHistory(String id) => '/reports/$id/history';
}
