// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_location_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the device-location request for the feed tab.
///
/// The feed is defined as "reports around me", so this is also its fetch
/// trigger: the listener turns a successful fix into a [FeedReports] load and
/// every other outcome into a designed state.

@ProviderFor(FeedLocation)
final feedLocationProvider = FeedLocationProvider._();

/// Owns the device-location request for the feed tab.
///
/// The feed is defined as "reports around me", so this is also its fetch
/// trigger: the listener turns a successful fix into a [FeedReports] load and
/// every other outcome into a designed state.
final class FeedLocationProvider
    extends $NotifierProvider<FeedLocation, AsyncValue<LocationResult?>> {
  /// Owns the device-location request for the feed tab.
  ///
  /// The feed is defined as "reports around me", so this is also its fetch
  /// trigger: the listener turns a successful fix into a [FeedReports] load and
  /// every other outcome into a designed state.
  FeedLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedLocationHash();

  @$internal
  @override
  FeedLocation create() => FeedLocation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<LocationResult?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<LocationResult?>>(value),
    );
  }
}

String _$feedLocationHash() => r'82563da49a9bc902380f951bbde70fb090052d7f';

/// Owns the device-location request for the feed tab.
///
/// The feed is defined as "reports around me", so this is also its fetch
/// trigger: the listener turns a successful fix into a [FeedReports] load and
/// every other outcome into a designed state.

abstract class _$FeedLocation extends $Notifier<AsyncValue<LocationResult?>> {
  AsyncValue<LocationResult?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<LocationResult?>, AsyncValue<LocationResult?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<LocationResult?>,
                AsyncValue<LocationResult?>
              >,
              AsyncValue<LocationResult?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
