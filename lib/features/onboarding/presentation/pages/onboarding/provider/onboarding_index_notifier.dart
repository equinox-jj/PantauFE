import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../widgets/onboarding_slide_data.dart';

part 'onboarding_index_notifier.g.dart';

@riverpod
class OnboardingIndex extends _$OnboardingIndex {
  @override
  int build() => 0;

  void next() {
    if (state < kOnboardingSlides.length - 1) state++;
  }

  void prev() {
    if (state > 0) state--;
  }

  void goTo(int index) {
    state = index.clamp(0, kOnboardingSlides.length - 1);
  }
}
