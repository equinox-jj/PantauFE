// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_location_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the device-location request for the map tab. Holds the raw
/// [LocationResult] so the listener can branch on permission outcomes.

@ProviderFor(MapLocation)
final mapLocationProvider = MapLocationProvider._();

/// Owns the device-location request for the map tab. Holds the raw
/// [LocationResult] so the listener can branch on permission outcomes.
final class MapLocationProvider
    extends $NotifierProvider<MapLocation, AsyncValue<LocationResult?>> {
  /// Owns the device-location request for the map tab. Holds the raw
  /// [LocationResult] so the listener can branch on permission outcomes.
  MapLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapLocationHash();

  @$internal
  @override
  MapLocation create() => MapLocation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<LocationResult?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<LocationResult?>>(value),
    );
  }
}

String _$mapLocationHash() => r'9e0ac3deac849544bbefae4d10ad7c928bf6f7e5';

/// Owns the device-location request for the map tab. Holds the raw
/// [LocationResult] so the listener can branch on permission outcomes.

abstract class _$MapLocation extends $Notifier<AsyncValue<LocationResult?>> {
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
