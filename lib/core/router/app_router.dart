import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login/login.dart';
import '../../features/auth/presentation/pages/register/register.dart';
import '../../features/dashboard/presentation/pages/dashboard/dashboard.dart';
import '../../features/map/presentation/pages/map/map.dart';
import '../../features/my_reports/presentation/pages/my_reports/my_reports.dart';
import '../../features/onboarding/presentation/pages/onboarding/onboarding.dart';
import '../../features/onboarding/presentation/pages/splash/splash.dart';
import '../../features/profile/presentation/pages/profile/profile.dart';
import '../../features/report/presentation/pages/feed/feed.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
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
                path: AppRoutes.myReports,
                builder: (context, state) => const MyReportsPage(),
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
});
