// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'is_resolver_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the signed-in user is a resolver, read from the locally cached
/// role — the same lookup `Splash` uses to decide which shell to land in.
/// Gates [ReportStatusActionPanel]: a citizen viewing this same shared detail
/// page never sees the status-change action.

@ProviderFor(isResolver)
final isResolverProvider = IsResolverProvider._();

/// Whether the signed-in user is a resolver, read from the locally cached
/// role — the same lookup `Splash` uses to decide which shell to land in.
/// Gates [ReportStatusActionPanel]: a citizen viewing this same shared detail
/// page never sees the status-change action.

final class IsResolverProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the signed-in user is a resolver, read from the locally cached
  /// role — the same lookup `Splash` uses to decide which shell to land in.
  /// Gates [ReportStatusActionPanel]: a citizen viewing this same shared detail
  /// page never sees the status-change action.
  IsResolverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isResolverProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isResolverHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isResolver(ref);
  }
}

String _$isResolverHash() => r'83e875b51db0c4d5879bfc436a03e3850b0cc833';
