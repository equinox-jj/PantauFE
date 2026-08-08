// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_tab_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which segment of the queue is showing. Lives outside the page so
/// switching tabs does not rebuild the whole screen, only what watches this.

@ProviderFor(QueueTabSelection)
final queueTabSelectionProvider = QueueTabSelectionProvider._();

/// Which segment of the queue is showing. Lives outside the page so
/// switching tabs does not rebuild the whole screen, only what watches this.
final class QueueTabSelectionProvider
    extends $NotifierProvider<QueueTabSelection, QueueTab> {
  /// Which segment of the queue is showing. Lives outside the page so
  /// switching tabs does not rebuild the whole screen, only what watches this.
  QueueTabSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueTabSelectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueTabSelectionHash();

  @$internal
  @override
  QueueTabSelection create() => QueueTabSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueueTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QueueTab>(value),
    );
  }
}

String _$queueTabSelectionHash() => r'0cd79ea4f3bfba4c74189f3874f8a3e960735382';

/// Which segment of the queue is showing. Lives outside the page so
/// switching tabs does not rebuild the whole screen, only what watches this.

abstract class _$QueueTabSelection extends $Notifier<QueueTab> {
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
