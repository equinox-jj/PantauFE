// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_completion_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnboardingCompletion)
final onboardingCompletionProvider = OnboardingCompletionProvider._();

final class OnboardingCompletionProvider
    extends $NotifierProvider<OnboardingCompletion, AsyncValue<bool>> {
  OnboardingCompletionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingCompletionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingCompletionHash();

  @$internal
  @override
  OnboardingCompletion create() => OnboardingCompletion();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<bool>>(value),
    );
  }
}

String _$onboardingCompletionHash() =>
    r'0ce6ca0af5a9e1da7c3df6f6215109ec9d50cc42';

abstract class _$OnboardingCompletion extends $Notifier<AsyncValue<bool>> {
  AsyncValue<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, AsyncValue<bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, AsyncValue<bool>>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
