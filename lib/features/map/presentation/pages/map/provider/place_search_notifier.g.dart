// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Results of the place-search field above the map.
///
/// A search runs on submit only, never per keystroke: the public Nominatim
/// instance asks callers not to drive autocomplete off `/search`, and one
/// request per submit stays inside its 1 request/second policy.

@ProviderFor(PlaceSearch)
final placeSearchProvider = PlaceSearchProvider._();

/// Results of the place-search field above the map.
///
/// A search runs on submit only, never per keystroke: the public Nominatim
/// instance asks callers not to drive autocomplete off `/search`, and one
/// request per submit stays inside its 1 request/second policy.
final class PlaceSearchProvider
    extends $NotifierProvider<PlaceSearch, AsyncValue<List<Place>>?> {
  /// Results of the place-search field above the map.
  ///
  /// A search runs on submit only, never per keystroke: the public Nominatim
  /// instance asks callers not to drive autocomplete off `/search`, and one
  /// request per submit stays inside its 1 request/second policy.
  PlaceSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placeSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placeSearchHash();

  @$internal
  @override
  PlaceSearch create() => PlaceSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Place>>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Place>>?>(value),
    );
  }
}

String _$placeSearchHash() => r'67e93b0e66b233800a7ff9c74d3e34d4569d4b50';

/// Results of the place-search field above the map.
///
/// A search runs on submit only, never per keystroke: the public Nominatim
/// instance asks callers not to drive autocomplete off `/search`, and one
/// request per submit stays inside its 1 request/second policy.

abstract class _$PlaceSearch extends $Notifier<AsyncValue<List<Place>>?> {
  AsyncValue<List<Place>>? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Place>>?, AsyncValue<List<Place>>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Place>>?, AsyncValue<List<Place>>?>,
              AsyncValue<List<Place>>?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
