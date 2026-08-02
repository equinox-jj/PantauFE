// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_index_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnboardingIndex)
final onboardingIndexProvider = OnboardingIndexProvider._();

final class OnboardingIndexProvider
    extends $NotifierProvider<OnboardingIndex, int> {
  OnboardingIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingIndexHash();

  @$internal
  @override
  OnboardingIndex create() => OnboardingIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$onboardingIndexHash() => r'5c59187c3f613229308ff5b713c5e65b825bcc70';

abstract class _$OnboardingIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
