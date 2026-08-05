/// Report API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class ReportEndpoint {
  /// Backs the feed as well as the map: the same radius query, read as a list.
  static const String nearbyReports = '/reports/nearby';
}
