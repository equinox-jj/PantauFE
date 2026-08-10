import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entity/resolver_entity.dart';

part 'selected_queue_report_notifier.g.dart';

/// The report whose preview card is showing, or null when none is
/// selected. Set by a marker tap, replaced by the next marker tap, cleared
/// when the active tab changes (the previous selection may not even be in
/// the new tab's result set).
@riverpod
class SelectedQueueReport extends _$SelectedQueueReport {
  @override
  QueueReport? build() => null;

  void select(QueueReport report) => state = report;

  void clear() => state = null;
}
