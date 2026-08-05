// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The last device position that resolved, for the pin marking it on the map.
///
/// Separate from `MapLocation`, which goes loading on every locate tap and
/// carries the permission outcome; the pin must stay put across a re-locate.

@ProviderFor(CurrentLocation)
final currentLocationProvider = CurrentLocationProvider._();

/// The last device position that resolved, for the pin marking it on the map.
///
/// Separate from `MapLocation`, which goes loading on every locate tap and
/// carries the permission outcome; the pin must stay put across a re-locate.
final class CurrentLocationProvider
    extends $NotifierProvider<CurrentLocation, LatLng?> {
  /// The last device position that resolved, for the pin marking it on the map.
  ///
  /// Separate from `MapLocation`, which goes loading on every locate tap and
  /// carries the permission outcome; the pin must stay put across a re-locate.
  CurrentLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLocationHash();

  @$internal
  @override
  CurrentLocation create() => CurrentLocation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LatLng? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LatLng?>(value),
    );
  }
}

String _$currentLocationHash() => r'54e86c66f8ab4a4d3f969f80f98167d8d79c7349';

/// The last device position that resolved, for the pin marking it on the map.
///
/// Separate from `MapLocation`, which goes loading on every locate tap and
/// carries the permission outcome; the pin must stay put across a re-locate.

abstract class _$CurrentLocation extends $Notifier<LatLng?> {
  LatLng? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LatLng?, LatLng?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LatLng?, LatLng?>,
              LatLng?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
