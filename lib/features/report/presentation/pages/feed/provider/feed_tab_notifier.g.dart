// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_tab_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which segment of the feed is showing. Lives outside the page so switching
/// tabs does not rebuild the whole screen, only what watches this.

@ProviderFor(FeedTabSelection)
final feedTabSelectionProvider = FeedTabSelectionProvider._();

/// Which segment of the feed is showing. Lives outside the page so switching
/// tabs does not rebuild the whole screen, only what watches this.
final class FeedTabSelectionProvider
    extends $NotifierProvider<FeedTabSelection, FeedTab> {
  /// Which segment of the feed is showing. Lives outside the page so switching
  /// tabs does not rebuild the whole screen, only what watches this.
  FeedTabSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedTabSelectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedTabSelectionHash();

  @$internal
  @override
  FeedTabSelection create() => FeedTabSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedTab>(value),
    );
  }
}

String _$feedTabSelectionHash() => r'2b2eb810f95b1d85ff1ad0f5c0102ff556bd35e3';

/// Which segment of the feed is showing. Lives outside the page so switching
/// tabs does not rebuild the whole screen, only what watches this.

abstract class _$FeedTabSelection extends $Notifier<FeedTab> {
  FeedTab build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FeedTab, FeedTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FeedTab, FeedTab>,
              FeedTab,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
