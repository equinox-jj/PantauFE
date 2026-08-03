/// Top-level route paths, shared by [GoRouter] configuration and every
/// screen/notifier that navigates.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  /// Full-screen compose flow, pushed over the dashboard shell.
  static const String createReport = '/create-report';

  // Dashboard shell — one branch (and one navigation stack) per tab.
  static const String map = '/map';
  static const String feed = '/feed';
  static const String myReports = '/my-reports';
  static const String profile = '/profile';

  /// Entry point of the authenticated shell: the map tab.
  static const String dashboard = map;

  static const List<String> all = [
    splash,
    onboarding,
    login,
    register,
    createReport,
    map,
    feed,
    myReports,
    profile,
  ];
}
