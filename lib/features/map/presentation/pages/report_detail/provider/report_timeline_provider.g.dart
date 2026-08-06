// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_timeline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Merges the report's history with the canonical ladder. Lives here rather
/// than in the card so the widget stays free of derivation logic.

@ProviderFor(reportTimeline)
final reportTimelineProvider = ReportTimelineFamily._();

/// Merges the report's history with the canonical ladder. Lives here rather
/// than in the card so the widget stays free of derivation logic.

final class ReportTimelineProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TimelineStep>>,
          List<TimelineStep>,
          FutureOr<List<TimelineStep>>
        >
    with
        $FutureModifier<List<TimelineStep>>,
        $FutureProvider<List<TimelineStep>> {
  /// Merges the report's history with the canonical ladder. Lives here rather
  /// than in the card so the widget stays free of derivation logic.
  ReportTimelineProvider._({
    required ReportTimelineFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reportTimelineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reportTimelineHash();

  @override
  String toString() {
    return r'reportTimelineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<TimelineStep>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TimelineStep>> create(Ref ref) {
    final argument = this.argument as String;
    return reportTimeline(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportTimelineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reportTimelineHash() => r'713065aec7b581000138bf304cf7af0f580bceeb';

/// Merges the report's history with the canonical ladder. Lives here rather
/// than in the card so the widget stays free of derivation logic.

final class ReportTimelineFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<TimelineStep>>, String> {
  ReportTimelineFamily._()
    : super(
        retry: null,
        name: r'reportTimelineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Merges the report's history with the canonical ladder. Lives here rather
  /// than in the card so the widget stays free of derivation logic.

  ReportTimelineProvider call(String reportId) =>
      ReportTimelineProvider._(argument: reportId, from: this);

  @override
  String toString() => r'reportTimelineProvider';
}
