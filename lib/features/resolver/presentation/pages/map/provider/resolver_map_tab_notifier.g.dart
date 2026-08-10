// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolver_map_tab_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The map's own tab selection. Independent of `QueueTabSelection` —
/// switching tabs on the map never changes what the Queue page shows next,
/// and vice versa. Defaults to the actionable "open" bucket.

@ProviderFor(ResolverMapTabSelection)
final resolverMapTabSelectionProvider = ResolverMapTabSelectionProvider._();

/// The map's own tab selection. Independent of `QueueTabSelection` —
/// switching tabs on the map never changes what the Queue page shows next,
/// and vice versa. Defaults to the actionable "open" bucket.
final class ResolverMapTabSelectionProvider
    extends $NotifierProvider<ResolverMapTabSelection, QueueTab> {
  /// The map's own tab selection. Independent of `QueueTabSelection` —
  /// switching tabs on the map never changes what the Queue page shows next,
  /// and vice versa. Defaults to the actionable "open" bucket.
  ResolverMapTabSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resolverMapTabSelectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resolverMapTabSelectionHash();

  @$internal
  @override
  ResolverMapTabSelection create() => ResolverMapTabSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueueTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QueueTab>(value),
    );
  }
}

String _$resolverMapTabSelectionHash() =>
    r'334230e9b1d973e98d96e7e019244d36857a5656';

/// The map's own tab selection. Independent of `QueueTabSelection` —
/// switching tabs on the map never changes what the Queue page shows next,
/// and vice versa. Defaults to the actionable "open" bucket.

abstract class _$ResolverMapTabSelection extends $Notifier<QueueTab> {
  QueueTab build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<QueueTab, QueueTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QueueTab, QueueTab>,
              QueueTab,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
