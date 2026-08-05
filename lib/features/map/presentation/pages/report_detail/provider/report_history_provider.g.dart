// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads one report's status history. Throws the [Failure] so the timeline
/// card can render it through `AsyncValue.error` without failing the page.

@ProviderFor(reportHistory)
final reportHistoryProvider = ReportHistoryFamily._();

/// Loads one report's status history. Throws the [Failure] so the timeline
/// card can render it through `AsyncValue.error` without failing the page.

final class ReportHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StatusHistoryEntry>>,
          List<StatusHistoryEntry>,
          FutureOr<List<StatusHistoryEntry>>
        >
    with
        $FutureModifier<List<StatusHistoryEntry>>,
        $FutureProvider<List<StatusHistoryEntry>> {
  /// Loads one report's status history. Throws the [Failure] so the timeline
  /// card can render it through `AsyncValue.error` without failing the page.
  ReportHistoryProvider._({
    required ReportHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reportHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reportHistoryHash();

  @override
  String toString() {
    return r'reportHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<StatusHistoryEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StatusHistoryEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return reportHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reportHistoryHash() => r'1c868d1dd5f2e90cb1ef9d742f00ff988e942c15';

/// Loads one report's status history. Throws the [Failure] so the timeline
/// card can render it through `AsyncValue.error` without failing the page.

final class ReportHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<StatusHistoryEntry>>, String> {
  ReportHistoryFamily._()
    : super(
        retry: null,
        name: r'reportHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads one report's status history. Throws the [Failure] so the timeline
  /// card can render it through `AsyncValue.error` without failing the page.

  ReportHistoryProvider call(String reportId) =>
      ReportHistoryProvider._(argument: reportId, from: this);

  @override
  String toString() => r'reportHistoryProvider';
}
