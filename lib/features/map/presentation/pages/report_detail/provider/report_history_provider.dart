import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../di/di.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/usecase/usecase.dart';

part 'report_history_provider.g.dart';

/// Loads one report's status history. Throws the [Failure] so the timeline
/// card can render it through `AsyncValue.error` without failing the page.
@riverpod
Future<List<StatusHistoryEntry>> reportHistory(Ref ref, String reportId) async {
  final usecase = ref.watch(getReportHistoryUsecaseProvider);
  final result = await usecase(GetReportHistoryParams(id: reportId));

  return result.fold((failure) => throw failure, (entries) => entries);
}
