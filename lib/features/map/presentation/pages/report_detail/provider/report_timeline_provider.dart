import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/utils/enums/enums.dart';
import 'report_detail_provider.dart';
import 'report_history_provider.dart';

part 'report_timeline_provider.g.dart';

/// How a timeline node renders: a completed transition, the state the report
/// sits in now, or a step it has not reached yet.
enum TimelineStepState { done, current, future }

/// One row of the status timeline.
typedef TimelineStep = ({
  ReportStatus status,
  DateTime? time,
  String? note,
  TimelineStepState state,
});

/// The happy-path ladder every report walks. Steps the report has not reached
/// are still shown, greyed, so the loop is visible end to end.
const List<ReportStatus> _statusLadder = [
  ReportStatus.reported,
  ReportStatus.acknowledged,
  ReportStatus.inProgress,
  ReportStatus.resolved,
];

/// Merges the report's history with the canonical ladder. Lives here rather
/// than in the card so the widget stays free of derivation logic.
@riverpod
Future<List<TimelineStep>> reportTimeline(Ref ref, String reportId) async {
  final history = await ref.watch(reportHistoryProvider(reportId).future);

  final steps = <TimelineStep>[];

  if (history.isEmpty) {
    // A report with no history still has a status; show it rather than an
    // empty card. `detail` is only needed here — reading it unconditionally
    // would tie this card's loading state to the page's detail provider.
    final detail = await ref.watch(reportDetailProvider(reportId).future);
    steps.add((
      status: detail.status,
      time: detail.createdAt,
      note: null,
      state: TimelineStepState.current,
    ));
  } else {
    for (var index = 0; index < history.length; index++) {
      final entry = history[index];
      steps.add((
        status: entry.toStatus,
        time: entry.createdAt,
        note: entry.note,
        state: index == history.length - 1
            ? TimelineStepState.current
            : TimelineStepState.done,
      ));
    }
  }

  final currentStatus = steps.last.status;
  final currentIndex = _statusLadder.indexOf(currentStatus);
  // Rejected, closed and unknown all leave the ladder: nothing is pending.
  if (currentIndex == -1) return steps;

  final reached = steps.map((step) => step.status).toSet();
  for (var index = currentIndex + 1; index < _statusLadder.length; index++) {
    final status = _statusLadder[index];
    if (reached.contains(status)) continue;

    steps.add((
      status: status,
      time: null,
      note: null,
      state: TimelineStepState.future,
    ));
  }

  return steps;
}
