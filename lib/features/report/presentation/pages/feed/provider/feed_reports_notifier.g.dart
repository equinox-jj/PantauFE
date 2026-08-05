// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_reports_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The nearby feed, newest fetch wins.
///
/// Distance is resolved here rather than in a derived provider because the
/// origin is the very position this fetch used — pairing them anywhere else
/// risks measuring against a newer fix than the list was loaded for.

@ProviderFor(FeedReports)
final feedReportsProvider = FeedReportsProvider._();

/// The nearby feed, newest fetch wins.
///
/// Distance is resolved here rather than in a derived provider because the
/// origin is the very position this fetch used — pairing them anywhere else
/// risks measuring against a newer fix than the list was loaded for.
final class FeedReportsProvider
    extends $NotifierProvider<FeedReports, AsyncValue<List<FeedItem>>> {
  /// The nearby feed, newest fetch wins.
  ///
  /// Distance is resolved here rather than in a derived provider because the
  /// origin is the very position this fetch used — pairing them anywhere else
  /// risks measuring against a newer fix than the list was loaded for.
  FeedReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedReportsHash();

  @$internal
  @override
  FeedReports create() => FeedReports();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<FeedItem>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<FeedItem>>>(value),
    );
  }
}

String _$feedReportsHash() => r'54d0b0173798c56cc65d5ad5bd870592460fd892';

/// The nearby feed, newest fetch wins.
///
/// Distance is resolved here rather than in a derived provider because the
/// origin is the very position this fetch used — pairing them anywhere else
/// risks measuring against a newer fix than the list was loaded for.

abstract class _$FeedReports extends $Notifier<AsyncValue<List<FeedItem>>> {
  AsyncValue<List<FeedItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<FeedItem>>, AsyncValue<List<FeedItem>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<FeedItem>>,
                AsyncValue<List<FeedItem>>
              >,
              AsyncValue<List<FeedItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
