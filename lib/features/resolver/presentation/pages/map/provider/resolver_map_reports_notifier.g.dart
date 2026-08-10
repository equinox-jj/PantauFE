// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolver_map_reports_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Reports plotted on the map for the active tab. One-shot fetch, no
/// pagination — re-locating or switching tabs is the only refresh trigger.

@ProviderFor(ResolverMapReports)
final resolverMapReportsProvider = ResolverMapReportsProvider._();

/// Reports plotted on the map for the active tab. One-shot fetch, no
/// pagination — re-locating or switching tabs is the only refresh trigger.
final class ResolverMapReportsProvider
    extends $NotifierProvider<ResolverMapReports, AsyncValue<QueueResult>> {
  /// Reports plotted on the map for the active tab. One-shot fetch, no
  /// pagination — re-locating or switching tabs is the only refresh trigger.
  ResolverMapReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resolverMapReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resolverMapReportsHash();

  @$internal
  @override
  ResolverMapReports create() => ResolverMapReports();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<QueueResult> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<QueueResult>>(value),
    );
  }
}

String _$resolverMapReportsHash() =>
    r'd69fe993784df64f9d6fbd145916a74ae1ed35c4';

/// Reports plotted on the map for the active tab. One-shot fetch, no
/// pagination — re-locating or switching tabs is the only refresh trigger.

abstract class _$ResolverMapReports extends $Notifier<AsyncValue<QueueResult>> {
  AsyncValue<QueueResult> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<QueueResult>, AsyncValue<QueueResult>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<QueueResult>, AsyncValue<QueueResult>>,
              AsyncValue<QueueResult>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
