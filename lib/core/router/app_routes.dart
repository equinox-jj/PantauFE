/// Top-level route paths, shared by [GoRouter] configuration and every
/// screen/notifier that navigates.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  static const List<String> all = [splash, onboarding, login, register];
}
