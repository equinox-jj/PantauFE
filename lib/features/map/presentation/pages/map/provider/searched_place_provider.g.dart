// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searched_place_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The place the user jumped to, marked with a pin on the map.
///
/// Separate from [PlaceSearch] for lifetime: the result list dies with the
/// panel, the pin stays until the search field is cleared.

@ProviderFor(SearchedPlace)
final searchedPlaceProvider = SearchedPlaceProvider._();

/// The place the user jumped to, marked with a pin on the map.
///
/// Separate from [PlaceSearch] for lifetime: the result list dies with the
/// panel, the pin stays until the search field is cleared.
final class SearchedPlaceProvider
    extends $NotifierProvider<SearchedPlace, Place?> {
  /// The place the user jumped to, marked with a pin on the map.
  ///
  /// Separate from [PlaceSearch] for lifetime: the result list dies with the
  /// panel, the pin stays until the search field is cleared.
  SearchedPlaceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchedPlaceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchedPlaceHash();

  @$internal
  @override
  SearchedPlace create() => SearchedPlace();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Place? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Place?>(value),
    );
  }
}

String _$searchedPlaceHash() => r'f66645f5883856a24e56eb050b64ce6eab32edba';

/// The place the user jumped to, marked with a pin on the map.
///
/// Separate from [PlaceSearch] for lifetime: the result list dies with the
/// panel, the pin stays until the search field is cleared.

abstract class _$SearchedPlace extends $Notifier<Place?> {
  Place? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Place?, Place?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Place?, Place?>,
              Place?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
