// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads one report by id. Throws the [Failure] so the sheet can render it
/// through `AsyncValue.error`.

@ProviderFor(reportDetail)
final reportDetailProvider = ReportDetailFamily._();

/// Loads one report by id. Throws the [Failure] so the sheet can render it
/// through `AsyncValue.error`.

final class ReportDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReportDetail>,
          ReportDetail,
          FutureOr<ReportDetail>
        >
    with $FutureModifier<ReportDetail>, $FutureProvider<ReportDetail> {
  /// Loads one report by id. Throws the [Failure] so the sheet can render it
  /// through `AsyncValue.error`.
  ReportDetailProvider._({
    required ReportDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reportDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reportDetailHash();

  @override
  String toString() {
    return r'reportDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ReportDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReportDetail> create(Ref ref) {
    final argument = this.argument as String;
    return reportDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reportDetailHash() => r'55284922f0436bdb470cfc8db0946485928294a5';

/// Loads one report by id. Throws the [Failure] so the sheet can render it
/// through `AsyncValue.error`.

final class ReportDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ReportDetail>, String> {
  ReportDetailFamily._()
    : super(
        retry: null,
        name: r'reportDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads one report by id. Throws the [Failure] so the sheet can render it
  /// through `AsyncValue.error`.

  ReportDetailProvider call(String reportId) =>
      ReportDetailProvider._(argument: reportId, from: this);

  @override
  String toString() => r'reportDetailProvider';
}
