import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/base/base.dart';
import '../../../../di/di.dart';

part 'onboarding_completion_notifier.g.dart';

@riverpod
class OnboardingCompletion extends _$OnboardingCompletion {
  @override
  AsyncValue<bool> build() => const AsyncData(false);

  /// Marks onboarding as seen. Best-effort: navigation should proceed even
  /// if persistence fails — worst case the user sees onboarding again next
  /// launch, which is an acceptable degradation, not an error state.
  Future<void> complete() async {
    state = const AsyncLoading();

    final usecase = ref.read(setOnboardingSeenUsecaseProvider);
    await usecase(const NoParams());

    state = const AsyncData(true);
  }
}
