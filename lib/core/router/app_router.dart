import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/register/register_page.dart';
import '../../features/onboarding/presentation/pages/onboarding/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash/splash_page.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
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
    ],
  );
});
