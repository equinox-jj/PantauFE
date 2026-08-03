// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visible_reports_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The report list currently on screen: the last successfully loaded page of
/// [nearbyReportsProvider], held across its loading and error states.
///
/// Markers would otherwise blink out on every pan-triggered refetch, and the
/// empty/error overlays would flash over a map that still has pins on it.
/// Listening (not watching) is what makes it a memo — the previous list
/// survives until a newer one arrives.

@ProviderFor(VisibleReports)
final visibleReportsProvider = VisibleReportsProvider._();

/// The report list currently on screen: the last successfully loaded page of
/// [nearbyReportsProvider], held across its loading and error states.
///
/// Markers would otherwise blink out on every pan-triggered refetch, and the
/// empty/error overlays would flash over a map that still has pins on it.
/// Listening (not watching) is what makes it a memo — the previous list
/// survives until a newer one arrives.
final class VisibleReportsProvider
    extends $NotifierProvider<VisibleReports, List<NearbyReport>> {
  /// The report list currently on screen: the last successfully loaded page of
  /// [nearbyReportsProvider], held across its loading and error states.
  ///
  /// Markers would otherwise blink out on every pan-triggered refetch, and the
  /// empty/error overlays would flash over a map that still has pins on it.
  /// Listening (not watching) is what makes it a memo — the previous list
  /// survives until a newer one arrives.
  VisibleReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visibleReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visibleReportsHash();

  @$internal
  @override
  VisibleReports create() => VisibleReports();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<NearbyReport> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<NearbyReport>>(value),
    );
  }
}

String _$visibleReportsHash() => r'fdc65dc6cd31825bb5ef04141ce84db14ea2ff75';

/// The report list currently on screen: the last successfully loaded page of
/// [nearbyReportsProvider], held across its loading and error states.
///
/// Markers would otherwise blink out on every pan-triggered refetch, and the
/// empty/error overlays would flash over a map that still has pins on it.
/// Listening (not watching) is what makes it a memo — the previous list
/// survives until a newer one arrives.

abstract class _$VisibleReports extends $Notifier<List<NearbyReport>> {
  List<NearbyReport> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<NearbyReport>, List<NearbyReport>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<NearbyReport>, List<NearbyReport>>,
              List<NearbyReport>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
