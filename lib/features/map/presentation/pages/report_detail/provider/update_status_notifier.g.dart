// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_status_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Advances a report's status. Same one-shot shape as `CreateReport` — no
/// family, so the action panel, the picker sheet and the page listener all
/// watch a single in-flight submission per detail-page visit. Autodispose
/// (no `keepAlive`) resets it the moment the page is left.

@ProviderFor(UpdateStatus)
final updateStatusProvider = UpdateStatusProvider._();

/// Advances a report's status. Same one-shot shape as `CreateReport` — no
/// family, so the action panel, the picker sheet and the page listener all
/// watch a single in-flight submission per detail-page visit. Autodispose
/// (no `keepAlive`) resets it the moment the page is left.
final class UpdateStatusProvider
    extends $NotifierProvider<UpdateStatus, AsyncValue<ReportDetail?>> {
  /// Advances a report's status. Same one-shot shape as `CreateReport` — no
  /// family, so the action panel, the picker sheet and the page listener all
  /// watch a single in-flight submission per detail-page visit. Autodispose
  /// (no `keepAlive`) resets it the moment the page is left.
  UpdateStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateStatusHash();

  @$internal
  @override
  UpdateStatus create() => UpdateStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ReportDetail?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ReportDetail?>>(value),
    );
  }
}

String _$updateStatusHash() => r'e15ca28bdebd8b390a7e5e0e4b7b53811d8e28a7';

/// Advances a report's status. Same one-shot shape as `CreateReport` — no
/// family, so the action panel, the picker sheet and the page listener all
/// watch a single in-flight submission per detail-page visit. Autodispose
/// (no `keepAlive`) resets it the moment the page is left.

abstract class _$UpdateStatus extends $Notifier<AsyncValue<ReportDetail?>> {
  AsyncValue<ReportDetail?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ReportDetail?>, AsyncValue<ReportDetail?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReportDetail?>, AsyncValue<ReportDetail?>>,
              AsyncValue<ReportDetail?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
