// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loaded_area_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Centre of the last nearby-reports fetch, kept for the ring the map draws
/// around it.
///
/// Deliberately not `CurrentLocation`: the fetch follows whatever the user
/// last asked to look at — the device position at startup, a searched place,
/// or the camera centre behind "Search this area" — and the ring has to mark
/// the ground actually loaded, not where the user happens to be standing.

@ProviderFor(LoadedArea)
final loadedAreaProvider = LoadedAreaProvider._();

/// Centre of the last nearby-reports fetch, kept for the ring the map draws
/// around it.
///
/// Deliberately not `CurrentLocation`: the fetch follows whatever the user
/// last asked to look at — the device position at startup, a searched place,
/// or the camera centre behind "Search this area" — and the ring has to mark
/// the ground actually loaded, not where the user happens to be standing.
final class LoadedAreaProvider extends $NotifierProvider<LoadedArea, LatLng?> {
  /// Centre of the last nearby-reports fetch, kept for the ring the map draws
  /// around it.
  ///
  /// Deliberately not `CurrentLocation`: the fetch follows whatever the user
  /// last asked to look at — the device position at startup, a searched place,
  /// or the camera centre behind "Search this area" — and the ring has to mark
  /// the ground actually loaded, not where the user happens to be standing.
  LoadedAreaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadedAreaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadedAreaHash();

  @$internal
  @override
  LoadedArea create() => LoadedArea();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LatLng? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LatLng?>(value),
    );
  }
}

String _$loadedAreaHash() => r'91d09541e019b0bf78ae7494c2ccb9a0fadaf9bb';

/// Centre of the last nearby-reports fetch, kept for the ring the map draws
/// around it.
///
/// Deliberately not `CurrentLocation`: the fetch follows whatever the user
/// last asked to look at — the device position at startup, a searched place,
/// or the camera centre behind "Search this area" — and the ring has to mark
/// the ground actually loaded, not where the user happens to be standing.

abstract class _$LoadedArea extends $Notifier<LatLng?> {
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
