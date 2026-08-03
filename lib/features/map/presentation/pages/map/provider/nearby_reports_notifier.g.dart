// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_reports_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Nearby reports for the current map camera. Keeping the previous markers
/// on screen while a pan refetch is in flight is not this notifier's job —
/// `visibleReportsProvider` memoises the last loaded list for that.

@ProviderFor(NearbyReports)
final nearbyReportsProvider = NearbyReportsProvider._();

/// Nearby reports for the current map camera. Keeping the previous markers
/// on screen while a pan refetch is in flight is not this notifier's job —
/// `visibleReportsProvider` memoises the last loaded list for that.
final class NearbyReportsProvider
    extends $NotifierProvider<NearbyReports, AsyncValue<List<NearbyReport>>> {
  /// Nearby reports for the current map camera. Keeping the previous markers
  /// on screen while a pan refetch is in flight is not this notifier's job —
  /// `visibleReportsProvider` memoises the last loaded list for that.
  NearbyReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbyReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbyReportsHash();

  @$internal
  @override
  NearbyReports create() => NearbyReports();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<NearbyReport>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<NearbyReport>>>(
        value,
      ),
    );
  }
}

String _$nearbyReportsHash() => r'5798c0a28f4837784f296f6bb03ed418d73acb4d';

/// Nearby reports for the current map camera. Keeping the previous markers
/// on screen while a pan refetch is in flight is not this notifier's job —
/// `visibleReportsProvider` memoises the last loaded list for that.

abstract class _$NearbyReports
    extends $Notifier<AsyncValue<List<NearbyReport>>> {
  AsyncValue<List<NearbyReport>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<NearbyReport>>,
              AsyncValue<List<NearbyReport>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<NearbyReport>>,
                AsyncValue<List<NearbyReport>>
              >,
              AsyncValue<List<NearbyReport>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
