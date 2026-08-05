/// Report API paths, relative to `ApiEndpoints.baseUrl`.
abstract final class ReportEndpoint {
  /// Backs the feed as well as the map: the same radius query, read as a list.
  static const String nearbyReports = '/reports/nearby';

  /// The authenticated citizen's own submissions, newest first.
  static const String myReports = '/reports/mine';
}
