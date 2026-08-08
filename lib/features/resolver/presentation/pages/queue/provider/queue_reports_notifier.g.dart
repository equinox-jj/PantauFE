// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_reports_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The active tab's queue, newest fetch wins.
///
/// Switching tabs calls [load] again rather than keeping three lists cached
/// — every response already carries fresh counts for all three tabs, so the
/// tab counts stay in sync across switches even though the list itself
/// refetches. Three parallel cached lists would be unnecessary complexity
/// for a first version.

@ProviderFor(QueueReports)
final queueReportsProvider = QueueReportsProvider._();

/// The active tab's queue, newest fetch wins.
///
/// Switching tabs calls [load] again rather than keeping three lists cached
/// — every response already carries fresh counts for all three tabs, so the
/// tab counts stay in sync across switches even though the list itself
/// refetches. Three parallel cached lists would be unnecessary complexity
/// for a first version.
final class QueueReportsProvider
    extends $NotifierProvider<QueueReports, AsyncValue<QueueListState>> {
  /// The active tab's queue, newest fetch wins.
  ///
  /// Switching tabs calls [load] again rather than keeping three lists cached
  /// — every response already carries fresh counts for all three tabs, so the
  /// tab counts stay in sync across switches even though the list itself
  /// refetches. Three parallel cached lists would be unnecessary complexity
  /// for a first version.
  QueueReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueReportsHash();

  @$internal
  @override
  QueueReports create() => QueueReports();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<QueueListState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<QueueListState>>(value),
    );
  }
}

String _$queueReportsHash() => r'2634d17f43196b3a3e5fdff071c2ddda2d499ae7';

/// The active tab's queue, newest fetch wins.
///
/// Switching tabs calls [load] again rather than keeping three lists cached
/// — every response already carries fresh counts for all three tabs, so the
/// tab counts stay in sync across switches even though the list itself
/// refetches. Three parallel cached lists would be unnecessary complexity
/// for a first version.

abstract class _$QueueReports extends $Notifier<AsyncValue<QueueListState>> {
  AsyncValue<QueueListState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<QueueListState>, AsyncValue<QueueListState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<QueueListState>,
                AsyncValue<QueueListState>
              >,
              AsyncValue<QueueListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
