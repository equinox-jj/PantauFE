// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_queue_report_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The report whose preview card is showing, or null when none is
/// selected. Set by a marker tap, replaced by the next marker tap, cleared
/// when the active tab changes (the previous selection may not even be in
/// the new tab's result set).

@ProviderFor(SelectedQueueReport)
final selectedQueueReportProvider = SelectedQueueReportProvider._();

/// The report whose preview card is showing, or null when none is
/// selected. Set by a marker tap, replaced by the next marker tap, cleared
/// when the active tab changes (the previous selection may not even be in
/// the new tab's result set).
final class SelectedQueueReportProvider
    extends $NotifierProvider<SelectedQueueReport, QueueReport?> {
  /// The report whose preview card is showing, or null when none is
  /// selected. Set by a marker tap, replaced by the next marker tap, cleared
  /// when the active tab changes (the previous selection may not even be in
  /// the new tab's result set).
  SelectedQueueReportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedQueueReportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedQueueReportHash();

  @$internal
  @override
  SelectedQueueReport create() => SelectedQueueReport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueueReport? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QueueReport?>(value),
    );
  }
}

String _$selectedQueueReportHash() =>
    r'8a0e3739c5b1a78743e0488a3132e929a9eeb1d5';

/// The report whose preview card is showing, or null when none is
/// selected. Set by a marker tap, replaced by the next marker tap, cleared
/// when the active tab changes (the previous selection may not even be in
/// the new tab's result set).

abstract class _$SelectedQueueReport extends $Notifier<QueueReport?> {
  QueueReport? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<QueueReport?, QueueReport?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QueueReport?, QueueReport?>,
              QueueReport?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
