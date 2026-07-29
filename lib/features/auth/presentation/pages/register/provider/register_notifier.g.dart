// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisterUser)
final registerUserProvider = RegisterUserProvider._();

final class RegisterUserProvider
    extends $NotifierProvider<RegisterUser, AsyncValue<Register?>> {
  RegisterUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerUserHash();

  @$internal
  @override
  RegisterUser create() => RegisterUser();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Register?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Register?>>(value),
    );
  }
}

String _$registerUserHash() => r'455dec1148c65b3f014268136e1d4a2376c2d151';

abstract class _$RegisterUser extends $Notifier<AsyncValue<Register?>> {
  AsyncValue<Register?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Register?>, AsyncValue<Register?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Register?>, AsyncValue<Register?>>,
              AsyncValue<Register?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
