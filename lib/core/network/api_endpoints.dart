class ApiEndpoints {
  const ApiEndpoints._();

  static const String kNoAuth = 'noAuth';
  static const String kRetried = 'retried';
  static const String baseUrl = 'http://127.0.0.1:8080/api/v1';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/users/me';

  /// Backs the feed as well as the map: the same radius query, read as a list.
  static const String nearbyReports = '/reports/nearby';
  static const String reportCategories = '/categories';
  static const String reports = '/reports';

  /// The authenticated citizen's own submissions, newest first.
  static const String myReports = '/reports/mine';
  static const String queue = '/reports/queue';
  static String reportDetail(String id) => '/reports/$id';
  static String reportHistory(String id) => '/reports/$id/history';
  static String reportStatus(String id) => '/reports/$id/status';
}
