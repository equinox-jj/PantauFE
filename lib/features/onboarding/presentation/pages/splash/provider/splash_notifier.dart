import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/base/base.dart';
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

    final resultFuture = usecase(const NoParams());
    final delay = Future<void>.delayed(kSplashMinDuration);

    final result = await resultFuture;
    await delay;

    return result.fold(
      (_) => AppRoutes.onboarding,
      (hasSeenOnboarding) =>
          hasSeenOnboarding ? AppRoutes.login : AppRoutes.onboarding,
    );
  }
}
