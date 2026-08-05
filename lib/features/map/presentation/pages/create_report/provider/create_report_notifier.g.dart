// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_report_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Submits a report. The photo rides along as a file part of the same
/// multipart request (see `docs/API_REQUEST.md`), so this is one call and the
/// page derives its progress copy from [AsyncValue.isLoading].

@ProviderFor(CreateReport)
final createReportProvider = CreateReportProvider._();

/// Submits a report. The photo rides along as a file part of the same
/// multipart request (see `docs/API_REQUEST.md`), so this is one call and the
/// page derives its progress copy from [AsyncValue.isLoading].
final class CreateReportProvider
    extends $NotifierProvider<CreateReport, AsyncValue<ReportDetail?>> {
  /// Submits a report. The photo rides along as a file part of the same
  /// multipart request (see `docs/API_REQUEST.md`), so this is one call and the
  /// page derives its progress copy from [AsyncValue.isLoading].
  CreateReportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createReportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createReportHash();

  @$internal
  @override
  CreateReport create() => CreateReport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ReportDetail?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ReportDetail?>>(value),
    );
  }
}

String _$createReportHash() => r'd252c1425af2eb5ec923ba9fdc50bf25ff8a75cc';

/// Submits a report. The photo rides along as a file part of the same
/// multipart request (see `docs/API_REQUEST.md`), so this is one call and the
/// page derives its progress copy from [AsyncValue.isLoading].

abstract class _$CreateReport extends $Notifier<AsyncValue<ReportDetail?>> {
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
