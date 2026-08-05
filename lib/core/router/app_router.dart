import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login/login.dart';
import '../../features/auth/presentation/pages/register/register.dart';
import '../../features/dashboard/presentation/pages/dashboard/dashboard.dart';
import '../../features/map/presentation/pages/create_report/create_report.dart';
import '../../features/map/presentation/pages/map/map.dart';
import '../../features/onboarding/presentation/pages/onboarding/onboarding.dart';
import '../../features/onboarding/presentation/pages/splash/splash.dart';
import '../../features/profile/presentation/pages/profile/profile.dart';
import '../../features/report/presentation/pages/feed/feed.dart';
import '../di/core_di.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.createReport,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateReportPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            DashboardPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.map,
                builder: (context, state) => const MapPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.feed,
                builder: (context, state) => const FeedPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // AuthInterceptor clears the token on a 401 and fires here; bounce the user
  // out of the authenticated shell so they can sign in again.
  final subscription = ref
      .watch(sessionManagerProvider)
      .onSessionExpired
      .listen((_) => router.go(AppRoutes.login));

  ref.onDispose(subscription.cancel);

  return router;
});
