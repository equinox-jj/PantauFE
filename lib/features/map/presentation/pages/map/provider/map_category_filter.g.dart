// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_category_filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The category the map is filtered to, or `null` for "All" (FR-10).
///
/// Holds an id rather than a `ReportCategory`: the taxonomy can be refetched,
/// so a selection stored as an entity would go stale.

@ProviderFor(MapCategoryFilter)
final mapCategoryFilterProvider = MapCategoryFilterProvider._();

/// The category the map is filtered to, or `null` for "All" (FR-10).
///
/// Holds an id rather than a `ReportCategory`: the taxonomy can be refetched,
/// so a selection stored as an entity would go stale.
final class MapCategoryFilterProvider
    extends $NotifierProvider<MapCategoryFilter, int?> {
  /// The category the map is filtered to, or `null` for "All" (FR-10).
  ///
  /// Holds an id rather than a `ReportCategory`: the taxonomy can be refetched,
  /// so a selection stored as an entity would go stale.
  MapCategoryFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapCategoryFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapCategoryFilterHash();

  @$internal
  @override
  MapCategoryFilter create() => MapCategoryFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$mapCategoryFilterHash() => r'c13a89493af05d2138a79307856d272707007213';

/// The category the map is filtered to, or `null` for "All" (FR-10).
///
/// Holds an id rather than a `ReportCategory`: the taxonomy can be refetched,
/// so a selection stored as an entity would go stale.

abstract class _$MapCategoryFilter extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
