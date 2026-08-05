// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_reports_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The reports drawn on the map: [visibleReportsProvider] narrowed by the
/// selected category.
///
/// Filtered client-side rather than through `GET /reports/nearby`, so chip
/// switching is synchronous and costs no refetch. The trade is that only the
/// loaded page is filtered; see the design doc's "Known constraint".

@ProviderFor(filteredReports)
final filteredReportsProvider = FilteredReportsProvider._();

/// The reports drawn on the map: [visibleReportsProvider] narrowed by the
/// selected category.
///
/// Filtered client-side rather than through `GET /reports/nearby`, so chip
/// switching is synchronous and costs no refetch. The trade is that only the
/// loaded page is filtered; see the design doc's "Known constraint".

final class FilteredReportsProvider
    extends
        $FunctionalProvider<
          List<NearbyReport>,
          List<NearbyReport>,
          List<NearbyReport>
        >
    with $Provider<List<NearbyReport>> {
  /// The reports drawn on the map: [visibleReportsProvider] narrowed by the
  /// selected category.
  ///
  /// Filtered client-side rather than through `GET /reports/nearby`, so chip
  /// switching is synchronous and costs no refetch. The trade is that only the
  /// loaded page is filtered; see the design doc's "Known constraint".
  FilteredReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredReportsHash();

  @$internal
  @override
  $ProviderElement<List<NearbyReport>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<NearbyReport> create(Ref ref) {
    return filteredReports(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<NearbyReport> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<NearbyReport>>(value),
    );
  }
}

String _$filteredReportsHash() => r'2b5c53ca446d89ac73ad9c09d97cbd3bd5a629fb';
