import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/base/base.dart';
import '../../../../../../core/di/core_di.dart';
import '../../../../../../core/router/app_routes.dart';
import '../../../../di/di.dart';

part 'splash_notifier.g.dart';

/// Minimum time the splash brand animation stays on screen.
const kSplashMinDuration = Duration(milliseconds: 1600);

@riverpod
class Splash extends _$Splash {
  @override
  Future<String> build() async {
    final usecase = ref.read(getOnboardingSeenUsecaseProvider);
    final tokenStorage = ref.read(tokenStorageProvider);

    final resultFuture = usecase(const NoParams());
    final tokenFuture = tokenStorage.readAccessToken();
    final delay = Future<void>.delayed(kSplashMinDuration);

    final result = await resultFuture;
    final token = await tokenFuture;
    await delay;

    // A stored token means the session survived the restart — skip login (and
    // onboarding, which an authenticated user has necessarily already passed).
    if (token != null && token.isNotEmpty) return AppRoutes.dashboard;

    return result.fold(
      (_) => AppRoutes.onboarding,
      (hasSeenOnboarding) =>
          hasSeenOnboarding ? AppRoutes.login : AppRoutes.onboarding,
    );
  }
}
